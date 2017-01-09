module Crux
  module Matcher
    class Prefix < Base
      property prefix

      def initialize(@prefix : String, predecessors : Enumerable(Matchable))
        previous = predecessors.select(&.is_a?(Matcher::Prefix)).last?
        @prefix = "#{previous}#{@prefix}"
      end

      def match?(context)
        context.request.path.starts_with?(@prefix)
      end

      def to_s(io)
        io << prefix
      end
    end
  end

  class Node
    def prefix(prefix)
      add_child(Matcher::Prefix.new(prefix, traversal.map(&.matcher)))
    end

    def prefix(pf)
      child = prefix(pf)
      with child yield child
      child
    end
  end
end
