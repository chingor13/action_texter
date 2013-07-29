module ActionTexter
  class Base < AbstractController::Base
    include DeliveryMethods
    abstract!

    include AbstractController::Logger
    include AbstractController::Rendering
    include AbstractController::Layouts
    include AbstractController::Helpers
    include AbstractController::Translation
    include AbstractController::AssetPaths

    self.protected_instance_variables = %w(@_action_has_layout)

    class_attribute :default_params
    self.default_params = {}.freeze

    class << self
      # Register one or more Observers which will be notified when mail is delivered.
      def register_observers(*observers)
        observers.flatten.compact.each { |observer| register_observer(observer) }
      end

      # Register one or more Interceptors which will be called before mail is sent.
      def register_interceptors(*interceptors)
        interceptors.flatten.compact.each { |interceptor| register_interceptor(interceptor) }
      end

      # Register an Observer which will be notified when mail is delivered.
      # Either a class or a string can be passed in as the Observer. If a string is passed in
      # it will be <tt>constantize</tt>d.
      def register_observer(observer)
        delivery_observer = (observer.is_a?(String) ? observer.constantize : observer)
        Mail.register_observer(delivery_observer)
      end

      # Register an Interceptor which will be called before mail is sent.
      # Either a class or a string can be passed in as the Interceptor. If a string is passed in
      # it will be <tt>constantize</tt>d.
      def register_interceptor(interceptor)
        delivery_interceptor = (interceptor.is_a?(String) ? interceptor.constantize : interceptor)
        Mail.register_interceptor(delivery_interceptor)
      end

      def texter_name
        @texter_name ||= name.underscore
      end
      attr_writer :texter_name
      alias :controller_path :texter_name

      def default(value = nil)
        self.default_params = default_params.merge(value).freeze if value
        default_params
      end

      def respond_to?(method, include_private = false)
        super || action_methods.include?(method.to_s)
      end

      protected

      def method_missing(method, *args)
        return super unless respond_to?(method)
        new(method, *args).message
      end
    end

    attr_internal :message

    def initialize(method_name = nil, *args)
      super()
      @_message = Message.new
      process(method_name, *args) if method_name
    end

    def process(*args)
      lookup_context.skip_default_locale!
      super
    end

    def texter_name
      self.class.texter_name
    end

    def text(headers={}, &block)
      m = @_message

      wrap_delivery_behavior!(headers.delete(:delivery_method))

      # Call all the procs (if any)
      default_values = self.class.default.merge(self.class.default) do |k,v|
        v.respond_to?(:call) ? v.bind(self).call : v
      end
      headers = headers.reverse_merge(default_values)
      headers.each do |k, v|
        m[k] = v
      end

      templates_path = self.class.texter_name
      templates_name = action_name

      each_template(templates_path, templates_name) do |template|
        m.body ||= render(:template => template)
      end
      m
    end

    def each_template(paths, name, &block)
      templates = lookup_context.find_all(name, Array.wrap(paths))
      templates.uniq_by { |t| t.formats }.each(&block)
    end

    ActiveSupport.run_load_hooks(:action_texter, self)
  end
end
