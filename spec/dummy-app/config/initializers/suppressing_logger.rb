Rails.application.config.middleware.swap Rails::Rack::Logger, ScanSuppressingLogger::Middleware, {
  networks: ['127.0.0.1']
} 