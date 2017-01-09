require "./spec_helper"

describe Crux do
  it "works" do
    request = FakeRequest.new(host: "localhost", method: "GET", path: "/foo/bar", scheme: "http")
    context = FakeContext.new(request: request)

    router = Crux::Router.new
    leaf = router.host("localhost").method(:get).prefix("/foo").path("/bar").scheme(:http)

    router.find(context).should eq(leaf)
  end

  it "is nestable" do
    leaf = nil

    request = FakeRequest.new(host: "localhost", method: "GET", path: "/foo/bar", scheme: "http")
    context = FakeContext.new(request: request)

    router = Crux::Router.new do |r|
      r.host("localhost") do |r|
        r.method(:get) do |r|
          r.prefix("/foo") do |r|
            r.path("/bar") do |r|
              leaf = r.scheme(:http)
            end
          end
        end
      end
    end

    router.find(context).should eq(leaf)
  end

  it "is nestable without block param" do
    leaf = nil

    request = FakeRequest.new(host: "localhost", method: "GET", path: "/foo/bar", scheme: "http")
    context = FakeContext.new(request: request)

    router = Crux::Router.new do
      host("localhost") do
        method(:get) do
          prefix("/foo") do
            path("/bar") do
              leaf = scheme(:http)
            end
          end
        end
      end
    end

    router.find(context).should eq(leaf)
  end

  it "captures variables and adds them to the context" do
    headers = HTTP::Headers.new
    headers["Host"] = "acme.example.com"

    request = HTTP::Request.new("GET", "/hello/world", headers)
    response = HTTP::Server::Response.new(IO::Memory.new(""))

    context = HTTP::Server::Context.new(request, response)

    handler_executed = false

    router = Crux::Router.new
    leaf = router.host(":subdomain.example.com").method(:get).prefix("/:foo").path("/:bar").handle do |context|
      context.params["undefined_capture"].should eq(nil)
      context.params["subdomain"].should eq("acme")
      context.params["foo"].should eq("hello")
      context.params["bar"].should eq("world")

      handler_executed = true
    end

    router.find(context).should eq(leaf)
    router.call(context)
    handler_executed.should eq(true)
  end

  it "doesn't keep erroneous match data" do
    request = FakeRequest.new(host: "localhost", method: "GET", path: "/foo/bar", scheme: "http")
    context = FakeContext.new(request: request)

    router = Crux::Router.new do
      prefix("/:meow") do
        path "/not_bar"
      end

      prefix("/:woof") do
        path "/bar"
      end
    end

    leaf = router.find(context)

    context.params["meow"].should eq(nil)
    context.params["woof"].should eq("foo")
  end
end
