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
end
