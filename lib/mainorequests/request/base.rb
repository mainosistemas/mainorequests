# frozen_string_literal: true

require "mainorequests/exceptions/forbidden_http_request_error"
require "ratelimit"

module MainoRequests
  module Request
    # Base class for all Requests implementations
    class Base
      %i[integration url_base headers authorization].each do |abstract_method|
        define_method abstract_method do
          raise NotImplementedError, "#{self.class} does not implements '#{__method__}'"
        end
      end

      def connection
        @connection ||= Faraday.new(integration.url_base) do |request|
          request.response :logger, logger, bodies: true
          request.adapter :httpclient
        end
      end

      def get(url, params = {})
        integration.execute_within_ratelimit do
          @response = integration.response.create_response(connection.get do |request|
            request.headers.merge!(integration.headers)
            request.url url, params
          end)
        end

        @response
      end

      def post(url, params = {})
        integration.execute_within_ratelimit do
          @response = integration.response.create_response(connection.post do |request|
            request.headers.merge!(integration.headers)
            request.url url
            request.body = params.to_json
          end)
        end

        @response
      end

      def put(url, params = {})
        integration.execute_within_ratelimit do
          @response = integration.response.create_response(connection.put do |request|
            request.headers.merge!(integration.headers)
            request.url url
            request.body = params.to_json
          end)
        end

        @response
      end

      def delete(url)
        integration.execute_within_ratelimit do
          @response = integration.response.create_response(connection.delete do |request|
            request.headers.merge!(integration.headers)
            request.url url
          end)
        end

        @response
      end

      def execute_within_ratelimit(&block)
        ratelimit.exec_within_threshold access_token, thershold: 3, interval: 1 do
          throttling.request(&block)

          ratelimit.add(access_token)
        end
      rescue MainoRequests::Exceptions::ForbiddenHTTPRequestError
        sleep 1
        integration.authorization.force_new_authentication
        retry
      end

      def ratelimit
        @ratelimit ||= Ratelimit.new(integration.ratelimit_redis_key, redis: redis)
      end

      def throttling
        @throttling ||= MainoRequests::Throttling.new(redis_key: integration.throttling_redis_key)
      end

      def response
        @response ||= MainoRequests::Response.new
      end

      def access_token
        @access_token ||= integration.authorization.access_token
      end

      def ratelimit_redis_key
        "integracao_#{redis_key_prefix}"
      end

      def throttling_redis_key
        "#{redis_key_prefix}:throttling:#{access_token}"
      end

      def redis_key_prefix
        integration.class.to_s.split("::").first&.downcase || "maino_request"
      end
    end
  end
end
