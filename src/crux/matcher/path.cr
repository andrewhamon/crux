require "./prefix"

module Crux
  module Matcher
    class Path < Prefix
      def match?(context)
        regex.match(context.request.path)
      end

      private def build_regex
        @regex = Regex.new("#{super.source}\\z")
      end
    end
  end

  class Node
    def path(pth)
      add_child(Matcher::Path.new(pth, traversal.map(&.matcher)))
    end

    def path(pth)
      child = path(pth)
      with child yield child
      child
    end
  end
end
