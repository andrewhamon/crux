require "http"
require "./node.cr"

class HTTP::Request
  def scheme
    uri.scheme
  end
end

module Crux
  module Matcher
    module Matchable
      abstract def match?(context)
    end

    abstract class Base
      include Matchable
    end
  end
end

require "./matcher/*"
