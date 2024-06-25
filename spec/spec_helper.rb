require "bundler/setup"
require "rails"
require "scan_suppressing_logger"

# Set up a dummy Rails app for testing
module Dummy
  class Application < Rails::Application
    config.root = File.dirname(__FILE__)
    config.eager_load = false
  end
end

Dummy::Application.initialize!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
