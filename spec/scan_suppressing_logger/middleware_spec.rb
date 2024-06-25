RSpec.describe ScanSuppressingLogger::Middleware do
  let(:app) { ->(env) { [200, env, "app"] } }

  let :middleware do
    ScanSuppressingLogger::Middleware.new(app)
  end

  context 'when Rollbar is defined' do
    before do
      stub_const("Rollbar", {})
    end

    it 'adds Rollbar to the set of wrappers' do
      wrappers = middleware.instance_eval { @wrappers }
      expect(wrappers).to include(ScanSuppressingLogger::RollbarWrapper)
    end
  end

  describe 'Replacing Rails::Rack::Logger' do
    it 'replaces Rails::Rack::Logger with ScanSuppressingLogger::Middleware' do
      expect(Rails.application.middleware).to include(ScanSuppressingLogger::Middleware)
      expect(Rails.application.middleware).not_to include(Rails::Rack::Logger)
    end

    context 'from a suppressed address' do
      it 'does not log the request' do
        # Expect the middleware to be called
        expect_any_instance_of(ScanSuppressingLogger::Middleware).to receive(:call).and_call_original
        # Expect the logger to report it was suppressed
        expect(Rails.logger).to receive(:info).with('Suppressed for 127.0.0.1')
        # Do not expect the original Rails::Rack::Logger to be called
        expect_any_instance_of(Rails::Rack::Logger).not_to receive(:call)

        # Make a simulated request to the app
        env = Rack::MockRequest.env_for('http://example.org/', 'REMOTE_ADDR' => '127.0.0.1')
        status, headers, body = Rails.application.call(env)
      end
    end

    context 'from a non-suppressed address' do
      it 'logs the request' do
        # Expect the original Rails::Rack::Logger to be called
        expect_any_instance_of(Rails::Rack::Logger).to receive(:call).and_call_original

        # Make a simulated request to the app
        env = Rack::MockRequest.env_for('/', 'REMOTE_ADDR' => '192.0.2.1')
        status, headers, body = Rails.application.call(env)
      end
    end
  end
end
