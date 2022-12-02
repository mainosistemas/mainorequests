# frozen_string_literal: true

require "date"

module MainoRequests
  module Throttling
    # Base class for all Throttling implementations
    class Base
      def initialize(redis_key:)
        @redis_key = redis_key
      end

      def retry_after=(seconds)
        @retry_after = (DateTime.now.to_time + seconds).to_datetime
        redis.set(redis_key, retry_after)
        redis.expireat(redis_key, retry_after.to_i)
      end

      def clear_retry_after
        @retry_after = nil
        redis.del(redis_key)
      end

      def retry_after
        @retry_after || redis.get(redis_key)&.to_datetime
      end

      def request
        if retry_after && retry_after > DateTime.now
          hold_request
          clear_retry_after
        end

        yield
      rescue MainoRequests::Exceptions::RatelimitError
        retry
      end

      private

      attr_reader :redis_key

      def hold_request
        sleep remaining_seconds.to_i
      end

      def remaining_seconds
        retry_after.to_i - DateTime.current.to_i
      end
    end
  end
end
