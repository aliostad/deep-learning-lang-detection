class Calculator
  attr_accessor :usage

  def initialize(usage)
    @usage = usage
  end

  def calculate
    calculation = {
      tensile: calculate_tensile_rating,
      ply: calculate_ply_count,
      minimum_pulley_diameter: calculate_minimum_pulley_diameter
    }
    calculation
  end

  def calculate_tensile_rating
  end

  # Recommended pulley diameter:
  #   FOR EP100
  #     12in or 304.8mm
  #     16in or 406.4mm
  #   FOR EP150
  #     16in or 406.4mm
  #     20in or 508mm
  #   EP 200 - 3P
  #     16in or 406.4mm
  #     22in or 558.8mm
  def calculate_minimum_pulley_diameter
    val = if calculate_tensile_rating == 100
      "val"
    elsif calculate_tensile_rating == nil
      "Cannot compute"
    end

    return val
  end

  def calculate_ply_count
  end

end
