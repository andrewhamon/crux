module Crux
  module Matcher
    class Prefix < Base
      property prefix
      property! regex : Regex

      def initialize(@prefix : String, predecessors : Enumerable(Matchable))
        previous = predecessors.select(&.is_a?(Matcher::Prefix)).last?
        @prefix = "#{previous}#{@prefix}"
        build_regex
      end

      def match?(context)
        regex.match(context.request.path)
      end

      def to_s(io)
        io << prefix
      end

      private def build_regex
        url_segments = @prefix.split("/")

        regex_segments = url_segments.map do |segment|
          if segment.starts_with?(":")
            "(?<#{segment[1..-1]}>[^\\/]+)"
          else
            segment
          end
        end

        regex_string = regex_segments.join("\\/")
        regex_string = "\\A#{regex_string}"

        @regex = Regex.new(regex_string)
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
