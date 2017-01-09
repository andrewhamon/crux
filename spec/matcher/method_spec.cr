require "../spec_helper"

describe Crux::Matcher::Method do
  it "matches requests with the same method" do
    matcher = Crux::Matcher::Method.new(:get)

    request = FakeRequest.new(method: "GET")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end

  it "doesn't match requests with differing method" do
    matcher = Crux::Matcher::Method.new(:get)

    request = FakeRequest.new(method: "POST")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_falsey
  end

  it "can match multiple methods" do
    matcher = Crux::Matcher::Method.new(:get, :post)

    request = FakeRequest.new(method: "POST")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy

    request = FakeRequest.new(method: "PATCH")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_falsey
  end

  it "accepts strings and tuples" do
    matcher = Crux::Matcher::Method.new(:get, "POST")

    request = FakeRequest.new(method: "POST")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end

  it "is case insensitive" do
    matcher = Crux::Matcher::Method.new(:get, "PoST")

    request = FakeRequest.new(method: "POSt")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end
end
