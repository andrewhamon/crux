module Crux
  module Matcher
    class Method < Base
      @methods : Array(String)

      def initialize(*methods : String | Symbol)
        @methods = methods.map(&.to_s).map(&.upcase).to_a
      end

      def match?(context)
        @methods.any? &.==(context.request.method.upcase)
      end
    end
  end

  class Node
    def method(*methods)
      add_child(Matcher::Method.new(*methods))
    end

    def method(*methods)
      child = method(*methods)
      with child yield child
      child
    end

    {% for name in ["get", "post", "patch", "put", "delete"] %}
      def {{name.id}}
        method(name)
      end

      def {{name.id}}
        child = method(name)
        with child yield child
        child
      end

      def {{name.id}}(path)
        method(name).path(path)
      end

      def {{name.id}}(path)
        child = method(name).path(path)
        with child yield child
        child
      end
    {% end %}
  end
end
