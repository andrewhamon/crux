require "./spec_helper"

describe Crux::Matcher::Any do
  it "always matches" do
    Crux::Matcher::Any.new.match?(FakeContext.new).should eq(true)
  end
end

describe Crux::Matcher::Prefix do
  it "matches if it is a prefix of a request" do
    matcher = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo/bar")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end

  it "matchest an exact match" do
    matcher = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end

  it "does not match if it is not a prefix" do
    matcher = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(false)
  end

  it "modifies itself appropriately when nested" do
    previous = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)
    matcher = Crux::Matcher::Prefix.new("/bar", [previous])

    matcher.prefix.should eq("/foo/bar")
  end
end

describe Crux::Matcher::Path do
  it "matches an exact path" do
    matcher = Crux::Matcher::Path.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end

  it "does not match if only a prefix" do
    matcher = Crux::Matcher::Path.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo/bar")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(false)
  end

  it "modifies itself appropriately when nested under a prefix" do
    previous = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)
    matcher = Crux::Matcher::Path.new("/bar", [previous])

    matcher.prefix.should eq("/foo/bar")
  end
end

describe Crux::Matcher::Method do
  it "matches requests with the same method" do
    matcher = Crux::Matcher::Method.new(:get)

    request = FakeRequest.new(method: "GET")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end

  it "doesn't match requests with differing method" do
    matcher = Crux::Matcher::Method.new(:get)

    request = FakeRequest.new(method: "POST")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(false)
  end

  it "can match multiple methods" do
    matcher = Crux::Matcher::Method.new(:get, :post)

    request = FakeRequest.new(method: "POST")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)

    request = FakeRequest.new(method: "PATCH")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(false)
  end

  it "accepts strings and tuples" do
    matcher = Crux::Matcher::Method.new(:get, "POST")

    request = FakeRequest.new(method: "POST")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end

  it "is case insensitive" do
    matcher = Crux::Matcher::Method.new(:get, "PoST")

    request = FakeRequest.new(method: "POSt")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end
end

describe Crux::Matcher::Scheme do
  it "matches the scheme" do
    matcher = Crux::Matcher::Scheme.new(:http)

    request = FakeRequest.new(scheme: "HTTP")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)

    request = FakeRequest.new(scheme: "HTTPS")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(false)
  end

  it "is case insensitive" do
    matcher = Crux::Matcher::Scheme.new("HTtps")

    request = FakeRequest.new(scheme: "hTTPS")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end
end

describe Crux::Matcher::Host do
  it "matches the host" do
    matcher = Crux::Matcher::Host.new("www.example.com")

    request = FakeRequest.new(host: "www.example.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)

    request = FakeRequest.new(host: "www.notexample.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(false)
  end

  it "is case insensitive" do
    matcher = Crux::Matcher::Host.new("WwW.examplE.COM")

    request = FakeRequest.new(host: "www.EXAMPLE.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should eq(true)
  end
end
