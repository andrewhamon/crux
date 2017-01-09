module Crux
  module Matcher
    class Scheme < Base
      def initialize(@scheme : String | Symbol)
        @scheme = @scheme.to_s.downcase
      end

      def match?(context)
        context.request.scheme.to_s.downcase == @scheme
      end
    end
  end

  class Node
    def scheme(s)
      add_child(Matcher::Scheme.new(s))
    end

    def scheme(s)
      child = scheme(s)
      with child yield child
      child
    end
  end
end
