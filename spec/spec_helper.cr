require "spec"
require "../src/crux"

class FakeRequest
  property path : String
  property method : String
  property scheme : String
  property host : String

  def initialize(*, @path = "/", @method = "GET", @scheme = "http", @host = "localhost")
  end
end

class FakeContext
  property request : FakeRequest
  def initialize(*, @request = FakeRequest.new)
  end
end
