require "../spec_helper"

describe Crux::Matcher::Path do
  it "matches an exact path" do
    matcher = Crux::Matcher::Path.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end

  it "does not match if only a prefix" do
    matcher = Crux::Matcher::Path.new("/foo", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/foo/bar")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_falsey
  end

  it "modifies itself appropriately when nested under a prefix" do
    previous = Crux::Matcher::Prefix.new("/foo", Array(Crux::Matcher::Matchable).new)
    matcher = Crux::Matcher::Path.new("/bar", [previous])

    matcher.prefix.should eq("/foo/bar")
  end

  it "will match dynamic segments" do
    matcher = Crux::Matcher::Path.new("/:foobar", Array(Crux::Matcher::Matchable).new)

    request = FakeRequest.new(path: "/hello")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
    matcher.match?(context).try &.["foobar"].should eq("hello")
  end
end
