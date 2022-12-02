# frozen_string_literal: true

require "mainorequests/exceptions/http_request_error"

module MainoRequests
  module Exceptions
    class ForbiddenHTTPRequestError < HTTPRequestError; end
  end
end
