actionpack_path = File.expand_path('../../../actionpack/lib', __FILE__)
$:.unshift(actionpack_path) if File.directory?(actionpack_path) && !$:.include?(actionpack_path)

require 'abstract_controller'
require 'action_view'
require 'action_texter/version'

module ActionTexter
  extend ::ActiveSupport::Autoload

  autoload :Base
  autoload :Message
  autoload :DeliveryMethods
  autoload :FileDelivery
  autoload :TestDelivery
  autoload :TwilioDelivery
  autoload :WhitelistProxyDelivery
end

if defined?(Rails)
  require 'action_texter/railtie'
end
