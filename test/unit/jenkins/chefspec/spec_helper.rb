require 'bundler/setup'
require 'rspec'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef_zero/server'

require_relative '../support/matchers'

server = ChefZero::Server.new(port: 4041)
server.start_background

at_exit do
  server.stop if server.running?
end

RSpec.configure do |config|
  config.platform  = 'ubuntu'
  config.version   = '14.04'
  config.log_level = :error
  config.raise_errors_for_deprecations!
end

ChefSpec::Coverage.start!
