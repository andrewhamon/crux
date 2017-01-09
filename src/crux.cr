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
