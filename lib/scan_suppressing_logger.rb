require 'rails'

module ScanSuppressingLogger; end

require_relative 'scan_suppressing_logger/version'
require_relative 'scan_suppressing_logger/rails_wrapper'
require_relative 'scan_suppressing_logger/rollbar_wrapper'
require_relative 'scan_suppressing_logger/middleware'