module ScanSuppressingLogger
  class RollbarWrapper
    def self.call
      Rollbar.with_config(enabled: false) do
        yield
      end
    end
  end
end