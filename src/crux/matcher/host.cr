module Crux
  module Matcher
    class Host < Base
      property! regex : Regex

      def initialize(@host : String)
        build_regex
      end

      def match?(context)
        regex.match(context.request.host.to_s.downcase)
      end

      private def build_regex
        path_segments = @host.split(".")

        regex_segments = path_segments.map do |segment|
          if segment.starts_with?(":")
            "(?<#{segment[1..-1]}>[^\\.]+)"
          else
            segment.downcase
          end
        end

        regex_string = regex_segments.join("\\.")
        regex_string = "\\A#{regex_string}\\z"

        @regex = Regex.new(regex_string)
      end
    end
  end

  class Node
    def host(h)
      add_child(Matcher::Host.new(h))
    end

    def host(h)
      child = host(h)
      with child yield child
      child
    end
  end
end
