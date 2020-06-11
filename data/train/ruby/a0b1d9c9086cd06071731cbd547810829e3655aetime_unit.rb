module TimeSpanner
  module TimeUnits

    class TimeUnit < Unit

      attr_reader :multiplier

      def initialize position, multiplier
        super position

        @multiplier = multiplier
      end

      def calculate duration, to = nil
        @duration = duration

        calculate_amount
        calculate_rest
      end


      private

      def calculate_amount
        @amount = ( ( duration * multiplier ).round 13 ).to_i
      end

      def calculate_rest
        @rest = duration - amount_in_seconds
      end

      def amount_in_seconds
        amount.to_r / multiplier
      end

    end

  end
end
