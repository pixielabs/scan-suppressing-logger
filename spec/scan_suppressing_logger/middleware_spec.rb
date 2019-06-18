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
end
