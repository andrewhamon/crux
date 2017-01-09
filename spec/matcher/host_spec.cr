require "../spec_helper"

describe Crux::Matcher::Host do
  it "matches the host" do
    matcher = Crux::Matcher::Host.new("www.example.com")

    request = FakeRequest.new(host: "www.example.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy

    request = FakeRequest.new(host: "www.notexample.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_falsey
  end

  it "is case insensitive" do
    matcher = Crux::Matcher::Host.new("WwW.examplE.COM")

    request = FakeRequest.new(host: "www.EXAMPLE.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
  end

  it "will match dynamic segments" do
    matcher = Crux::Matcher::Host.new(":foobar.example.com")

    request = FakeRequest.new(host: "hello.example.com")
    context = FakeContext.new(request: request)

    matcher.match?(context).should be_truthy
    matcher.match?(context).try &.["foobar"].should eq("hello")
  end
end
