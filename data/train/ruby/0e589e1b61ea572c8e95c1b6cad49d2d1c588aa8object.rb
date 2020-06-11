module Sim

  class Object
    include Buildable

    attr_reader :delay

    default_attr :sim_threshold, 0.25

    def initialize
      @last_touched = 0.0
    end

    def touch time_unit
      @last_touched = time_unit
    end

    def update_simulation time_units = nil
      @delay =  (time_units || now) - @last_touched
      if @delay >= sim_threshold
        touch now
        sim
      end
    end

    def calculate delay
      raise "implement in subclass"
    end

    def sim
      calculate_steps
    end

    def calculate_steps
      delay.floor.times do
        calculate(1.0)
      end
      calculate(delay % 1.0)
    end

    def now
      Celluloid::Actor[:time_unit]&.time_elapsed
    end

  end

end
