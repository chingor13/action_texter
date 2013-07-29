module ActionTexter
  class Message
    attr_accessor :to, :from, :body

    attr_accessor :delivery_handler, :perform_deliveries, :raise_delivery_errors
    attr_reader :delivery_method, :delivery_options

    def initialize(attrs = {})
      attrs.each do |k, v|
        self.send("#{k}=", v) if self.respond_to?("#{k}=")
      end
    end

    def []=(k, v)
      self.send("#{k}=", v) if self.respond_to?("#{k}=")
    end

    def [](k)
      self.send(k) if self.respond_to?(k)
    end

    def deliver
      return false unless perform_deliveries
      begin
        @delivery_method.deliver(self)
      rescue => e
        raise e if raise_delivery_errors
      end
    end

    def delivery_method(method = nil, opts = {})
      unless method
        @delivery_method
      else
        @delivery_method = method.new(opts)
      end
    end
  end
end
