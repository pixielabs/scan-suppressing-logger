require "bundler/setup"
require "rails"
require "action_controller/railtie"
require "scan_suppressing_logger"

# Setup a dummy Rails app
module Dummy
  class Application < Rails::Application
    config.root = File.dirname(__FILE__)
  end
end

# Impossible to do this in a test; so you only get one shot setting it up.
Rails.application.configure do
  config.middleware.swap Rails::Rack::Logger, ScanSuppressingLogger::Middleware, {
    networks: ['127.0.0.1']
  }

  config.eager_load = false
  config.hosts.clear
end

Rails.application.initialize!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
