module ActionTexter
  class TwilioDelivery
    attr_reader :client

    def initialize(config = {})
      @sid = config[:sid]
      @token = config[:token]
      @subaccount = config[:subaccount]
      raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :sid" unless @sid
      raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :token" unless @token
      @client = Twilio::REST::Client.new(@sid, @token)
      @client = client.accounts.find(@subaccount) if @subaccount
    end

    def deliver(message)
      client.sms.messages.create(
        :from => message.from,
        :to => message.to,
        :body => message.body.strip
      )
    end
  end
end
