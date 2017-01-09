module Crux
  module Matcher
    class Any < Base
      def match?(context)
        true
      end
    end
  end
end
