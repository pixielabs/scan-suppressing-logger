module ScanSuppressingLogger
  class RailsWrapper
    def self.call
      Rails.logger.silence do
        yield
      end
    end
  end
end