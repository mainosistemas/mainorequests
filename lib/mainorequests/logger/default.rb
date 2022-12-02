require "logger"

module MainoRequests
  module Logger
    class Default
      attr_reader :logger

      def initialize
        @logger = ::Logger.new($stdout)
        @logger.level = ::Logger::WARN
      end
    end
  end
end
