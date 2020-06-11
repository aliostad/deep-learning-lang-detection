# -*- encoding : utf-8 -*-
class PercentileCalculator

  def initialize(values)
    @values = values.sort

    @eightisixth_percentile = calculate(86)
    @seventh_decile = calculate(70)
    @forth_decile = calculate(40)
  end

  def find_group(value)
    if value >= @eightisixth_percentile
      return 1
    elsif value >= @seventh_decile
      return 2
    elsif value >= @forth_decile
      return 3
    else
      return 4
    end
  end

  private
  def calculate(percentile)
    rank = ((@values.length.to_f/100.0) * percentile + 0.5).ceil
    @values[rank - 1]
  end

end
