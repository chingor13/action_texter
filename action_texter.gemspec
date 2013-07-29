require File.expand_path('../lib/action_texter/version', __FILE__)
Gem::Specification.new do |s|
  s.name = "action_texter"
  s.version = ActionTexter::VERSION::STRING
  s.description = 'Allows you to build text messages similar to ActionMailer'
  s.summary = 'Allows you to build text messages similar to ActionMailer'
  s.add_dependency "activesupport", ">= 3.0.0"

  s.author = "Jeff Ching"
  s.email = "jeff@chingr.com"
  s.homepage = "http://github.com/chingor13/action_texter"
  s.extra_rdoc_files = ['README.rdoc']
  s.has_rdoc = true

  s.files = `git ls-files`.split("\n")
  s.test_files = Dir.glob('test/*_test.rb')
end

