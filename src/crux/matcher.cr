require "http"
require "./node"

class HTTP::Server::Context
  property! params : Crux::Matcher::MatchData
end

class HTTP::Request
  def scheme
    uri.scheme
  end
end

module Crux
  module Matcher
    module Matchable
      abstract def match?(context) : MatchData
    end

    abstract class Base
      include Matchable
    end

    class MatchData
      property match_datas : Array(Regex::MatchData)

      def initialize
        @match_datas = Array(Regex::MatchData).new
      end

      def initialize(*match_datas : Regex::MatchData)
        @match_datas = match_datas.to_a
      end

      def [](key)
        match_datas.each do |md|
          val = md[key]?
          return val if val
        end
        nil
      end

      def <<(match_data)
        match_datas << match_data
      end

      def pop
        match_datas.pop
      end
    end
  end
end

require "./matcher/*"
