# frozen_string_literal: true

require_relative "mainorequests/version"
require "mainorequests/logger/default"
require "mainorequests/request/base"

module MainoRequests
  class << self
    attr_reader :integration, :redis
    attr_accessor :logger

    def new(integration:, redis:)
      @integration = integration
      @redis = redis
      @logger = MainoRequests::Logger::Default.new.logger

      MainoRequests::Request::Base.new
    end
  end
end
