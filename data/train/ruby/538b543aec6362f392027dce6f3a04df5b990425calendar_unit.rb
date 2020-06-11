module TimeSpanner
  module TimeUnits

    class CalendarUnit < Unit

      attr_accessor :from

      def initialize(position)
        super position
      end

      def calculate(duration, to)
        @duration = duration
        @from     = to - (self.duration.to_r)
        @amount   = calculate_amount(from, to)

        calculate_rest(at_amount, to)
      end


      private

      def calculate_rest(from, to)
        @rest = to.to_time.to_r - from.to_r
      end

    end
  end

end
