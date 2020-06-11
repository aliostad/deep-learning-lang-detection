module Brewery
  module Calc
    class StrikeWaterTemperature

      INITIAL_TEMPERATURE = 72 # degrees Fahrenheit 

      def initialize(target_temp, ratio)
        @target_temp = target_temp.to_f
        @ratio = ratio.to_f
      end

      def calculate
        @result ||= _calculate_strike_temperature.round
      end

      private

      attr_reader :ratio, :target_temp

      def _calculate_strike_temperature
        (0.2/ratio) * (target_temp - INITIAL_TEMPERATURE) + target_temp
      end

    end
  end
end
