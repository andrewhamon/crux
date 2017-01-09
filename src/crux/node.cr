require "http"

module Crux
  class Node < HTTP::Handler
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
      # Not a match, don't look any further
      return nil unless matcher.match?(context)

      # Is match and leaf, search is over
      return self if children.empty?

      # Not a leaf, try children
      children.each do |child|
        result = child.find(context)
        return result if result
      end

      # Nothing matches, return nil
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
