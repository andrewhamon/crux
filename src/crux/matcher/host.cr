module Crux
  module Matcher
    class Host < Base
      def initialize(@host : String)
        @host = @host.downcase
      end

      def match?(context)
        context.request.host.to_s.downcase == @host
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
