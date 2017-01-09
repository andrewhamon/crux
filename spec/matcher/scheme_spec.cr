require "../spec_helper"

describe Crux::Matcher::Scheme do
  it "matches the scheme" do
    matcher = Crux::Matcher::Scheme.new(:http)

    request = FakeRequest.new(scheme: "HTTP")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy

    request = FakeRequest.new(scheme: "HTTPS")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_falsey
  end

  it "is case insensitive" do
    matcher = Crux::Matcher::Scheme.new("HTtps")

    request = FakeRequest.new(scheme: "hTTPS")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end
end
