module ActionTexter
  class FileDelivery
    attr_reader :location
    def initialize(config = {})
      @location = config[:location]
      raise ArgumentError, "you must specify config.action_texter.file_settings to contain a :location" unless @location
      Dir.mkdir(@location) unless Dir.exists?(@location)
    end

    def deliver(message)
      File.open(File.join(location, "#{message.to}.txt"), "a") do |file|
        file.puts("FROM: #{message.from}")
        file.puts(message.body)
        file.puts("-"*40)
      end
      true
    end
  end
end
