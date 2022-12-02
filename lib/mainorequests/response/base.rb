# frozen_string_literal: true

require "logger"

module MainoRequests
  module Response
    # Base class for all Response implementations
    class Base
      attr_reader :body, :response

      def create_response(response)
        @response = response
        @body = formata_body

        log_output
        self
      end

      def success?
        response.success?
      end

      private

      def formata_body
        JSON.parse(response.body)
      rescue JSON::ParserError
        response.body
      end

      def log_output
        logger.info("Response - Status #{response.status}")
        logger.info("Headers: #{response.headers}")
        logger.info(body.to_s)
      end
    end
  end
end
