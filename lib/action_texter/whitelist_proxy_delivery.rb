module ActionTexter
  class WhitelistProxyDelivery
    class BlockedDelivery < StandardError; end
    attr_reader :delivery_method, :whitelist

    def initialize(config = {})
      @delivery_method = config[:delivery_method]
      @whitelist = config[:whitelist]
      raise ArgumentError, "you must specify config.action_texter.whitelist_proxy_settings to contain a :delivery_method" unless @delivery_method
      raise ArgumentError, "you must specify config.action_texter.whitelist_proxy_settings to contain a :whitelist" unless @whitelist
    end

    def deliver(message)
      raise BlockedDelivery if blocked?(message.to)

      real_delivery_method.deliver(message)
    end

    protected

    def blocked?(to)
      !whitelist.include?(to.to_s)
    end

    def real_delivery_method
      @real_delivery_method ||= begin
        settings = ActionTexter::Base.send(:"#{self.delivery_method}_settings")
        ActionTexter::Base.delivery_methods[self.delivery_method].new(settings)
      end
    end
  end
end
