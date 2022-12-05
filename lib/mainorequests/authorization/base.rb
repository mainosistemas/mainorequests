# frozen_string_literal: true

require "redis"

module MainoRequests
  module Authorization
    # Base class for all Auth implementations for MainoRequests
    class Base
      def initialize(request:)
        self.request = request
      end

      %i[token_request token_expires_in token_value].each do |abstract_method|
        define_method abstract_method do
          raise NotImplementedError, "#{self.class} does not implements '#{__method__}'"
        end
      end

      def cache_key
        "#{request.redis_key_prefix}:token"
      end

      def access_token
        cached_token || fetch_new_token
      end

      def cached_token
        @cached_token ||= redis.get(cache_key)
      end

      def fetch_new_token
        self.response ||= request.integration.response.create_response(token_request)
        return unless response.success?

        redis.set(cache_key, token_value)
        redis.expire(cache_key, token_expires_in)
      end

      def force_new_authentication
        redis.del(cache_key)
        request.access_token = nil
      end

      private

      attr_accessor :request, :response
    end
  end
end
