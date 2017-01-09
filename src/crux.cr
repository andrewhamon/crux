require "./crux/*"
require "http/server"

module Crux
  module Route
    def self.new
      Crux::Node.new()
    end

    def self.new
      r = Crux::Node.new()
      with r yield r
      r
    end
  end

  module Router
    def self.new
      Crux::Node.new()
    end

    def self.new
      r = Crux::Node.new()
      with r yield r
      r
    end
  end
end


# router = Crux::Router.new
#
# router.prefix("/:foo/:bar").handle do |context|
#   context.response.print "#{context.crux_params["foo"]} #{context.crux_params["bar"]}"
# end
#
# HTTP::Server.new("0.0.0.0", 8080, [
#   HTTP::ErrorHandler.new,
#   HTTP::LogHandler.new,
#   router,
# ]).listen
