module Joule
  module Base
    class Parser
      include Joule::Calculator::MarkerCalculator
      include Joule::Calculator::PeakPowerCalculator
      
      attr_accessor :workout
      
      def initialize(data)
        @data = data  
        @workout = Workout.new
      end

      # Parse powermeter data.
      # == Options
      #
      # * <tt>:calculate_marker_values </tt> - calculate the totals, averages, and maximum values for each Marker.
      #
      # * <tt>:calculate_peak_power_values </tt> - calculate the PeakPower values for the Workout.
      #
      # * <tt>:durations </tt> - an Array of durations (in seconds) of the PeakPower values that you want to calculate.  Required if :calculate_peak_power_values => true.
      #


      def parse(options = {})

        parse_properties
        parse_workout
        
        if(options[:calculate_marker_values])
          calculate_marker_values()
        end

        if(options[:calculate_peak_power_values])
          calculate_peak_power_values(:durations => options[:durations], :total_duration => @workout.markers.first.duration_seconds)
        end
        @workout
      end
      
      def parse_workout
        raise NotImplementedError
      end

      def parse_properties
        raise NotImplementedError
      end
    end    
    
  end
end
