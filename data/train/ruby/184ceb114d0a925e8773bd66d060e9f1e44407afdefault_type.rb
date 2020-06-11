module EJSONExt
  module Encoders
    class DefaultType
      def initialize(key, value)
        @key = key
        @value = value
      end

      def handler?
        true
      end

      def next_handler
        @next_handler || DefaultType.new(key, value)
      end

      def next_handler=(handler)
        @next_handler = handler
      end

      def parse
        if handler?
          [key, value]
        else
          next_handler.parse
        end
      end

      private

      attr_reader :key, :value
    end
  end
end
