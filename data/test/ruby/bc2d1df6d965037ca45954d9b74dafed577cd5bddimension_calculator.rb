module Sousenkyo
  class DimensionCalculator
    attr_reader :ticket

    def initialize(ticket)
      @ticket = ticket
    end
    
    def serial_code_area
      {
        x: calculate_x,
        y: calculate_y,
        width: calculate_width,
        height: calculate_height
      }
    end

    private

    def px_per_centimeter
      @px_per_centimeter ||= (short_side / ticket.width_in_cm)
    end

    def short_side
      [ticket.width_in_px, ticket.height_in_px].min
    end

    def calculate_x
      ticket.upper_left_x * px_per_centimeter      
    end

    def calculate_y
      ticket.upper_left_y * px_per_centimeter      
    end

    def calculate_width
      ticket.serial_code_width * px_per_centimeter      
    end

    def calculate_height
      ticket.serial_code_height * px_per_centimeter      
    end
  end
end
