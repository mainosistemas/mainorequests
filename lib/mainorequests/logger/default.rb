# frozen_string_literal: true

require "logger"

module MainoRequests
  module Logger
    # Default logger for the entire project
    class Default
      attr_reader :logger

      def initialize
        @logger = ::Logger.new($stdout)
        @logger.level = ::Logger::WARN
      end
    end
  end
end
