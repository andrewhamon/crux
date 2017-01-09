require "http"

module Crux
  class Node
    include HTTP::Handler

    property matcher : Crux::Matcher::Matchable
    property! handler : HTTP::Handler | HTTP::Handler::Proc
    property children = Array(self).new
    property! traversal : Array(self)

    def initialize(@matcher = Matcher::Any.new, traversal = Array(self).new)
      @traversal = traversal.dup.push(self)
    end

    def add_child(matcher)
      child = self.class.new(matcher, traversal)
      children << child
      child
    end

    def handle(h)
      @handler = h
      self
    end

    def handle(&h : HTTP::Handler::Proc)
      @handler = h
      self
    end

    # Find first matching path through the tree and return the leaf node
    def find(context)

      context.params = Crux::Matcher::MatchData.new unless context.params?

      match_data = matcher.match?(context)

      # Not a match, don't look any further
      return nil unless match_data

      context.params << match_data if match_data.is_a?(Regex::MatchData)

      # Is match and leaf, search is over
      return self if children.empty?

      # Not a leaf, try children
      children.each do |child|
        result = child.find(context)
        return result if result
      end

      # Nothing matches, return nil
      context.params.pop if match_data.is_a?(Regex::MatchData)
      return nil
    end

    def call(context)
      if handler?
        handler.call(context)
        return
      end

      n = find(context)
      if n
        n.call(context)
      else
        call_next(context)
      end
    end
  end
end
