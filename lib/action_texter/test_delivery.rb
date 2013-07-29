module ActionTexter
  class TestDelivery
    cattr_accessor :deliveries
    self.deliveries = []

    def initialize(config = {})
    end

    def deliver(message)
      self.class.deliveries << message
      true
    end
  end
end
