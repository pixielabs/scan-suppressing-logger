# Public: Suppresses Rails logs and exception reporting from automated scan
# requests.
#
# Use it by replacing the default Rails::Rack::Logger in config/application.rb:
#
# config.middleware.swap Rails::Rack::Logger, ScanSuppressingLogger::Middleware, {
#   networks: ['123.0.2.2/24', '86.54.222.1/16'],
# }
module ScanSuppressingLogger
  class Middleware < Rails::Rack::Logger
    def initialize(app, options = {})
      @app = app
      @options = options
      @wrappers = [ScanSuppressingLogger::RailsWrapper]

      configure_networks!
      find_error_trackers!

      super
    end

    def call(env)
      return super(env) unless @configured

      request = ActionDispatch::Request.new env
      if automated_scan? request
        Rails.logger.tagged('ScanSuppressingLogger') { Rails.logger.info "Suppressed for #{request.remote_ip}" }

        # Combine all the wrappers we need.
        @wrappers.inject(proc { @app.call env }) do |acc, wrapper|
          proc { wrapper.call(&acc) }
        end.call
      else
        super env
      end
    end

    def automated_scan?(request)
      # Check if the request source IP comes from any of the network ranges
      # in config.
      ip = IPAddr.new request.remote_ip
      @networks.any?{|network| network.include? ip }
    end

    private
    def configure_networks!
      @networks = @options.delete(:networks)

      if @networks && @networks.is_a?(Array)
        @configured = true
        @networks = @networks.
          map{|network| IPAddr.new network } 
      else
        puts "You need to pass a networks option to ScanSuppressingLogger."
        puts "For more info, check the README: https://github.com/pixielabs/scan-suppressing-logger"
      end
    end

    # Internal: Find loaded error trackers and build up a list of wrappers.
    def find_error_trackers!
      @wrappers << ScanSuppressingLogger::RollbarWrapper if defined?(::Rollbar)
    end
  end
end