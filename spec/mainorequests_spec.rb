# frozen_string_literal: true
require "pry"
require "redis"

RSpec.describe Mainorequests do
  it "has a version number" do
    expect(Mainorequests::VERSION).not_to be nil
  end

  xit "creates integration requests" do
    ConcreteRequest.new.request
  end
end

class ConcreteRequest
  def request
    MainoRequests.new(integration: self, redis: redis)
  end

  private

  def redis
    Redis.new(url: "redis://localhost:6379/1")
  end
end
