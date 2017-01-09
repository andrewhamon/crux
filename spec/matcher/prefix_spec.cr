require "../spec_helper"

describe Crux::Matcher::Prefix do
  it "matches if it is a prefix of a request" do
    matcher = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo/bar")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end

  it "matchest an exact match" do
    matcher = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end

  it "does not match if it is not a prefix" do
    matcher = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_falsey
  end

  it "modifies itself appropriately when nested" do
    previous = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)
    matcher = Crux::Matcher::Prefix.new("/bar", [previous])

    matcher.prefix.should eq("/foo/bar")
  end

  it "will match dynamic segments" do
    matcher = Crux::Matcher::Prefix.new("/:foobar", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/hello")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
    matcher.match?(context).try &.["foobar"].should eq("hello")
  end
end
