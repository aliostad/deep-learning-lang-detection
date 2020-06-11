
class HeroCreation

  attr_reader :points

  BASIC_ATTR = [:st, :dx, :ht, :iq]
  ALL_ATTR = [:st, :dx, :ht, :iq, :bl, :hp, :wl, :per, :fp, :bsp]

  def initialize(template)
    @template = template
    @tunings = ALL_ATTR.inject({}) { |memo, attr|
      memo[attr] = 0
      memo
    }
    @points = powerlevel
  end

  def powerlevel
    @template[:powerlevel]
  end

  def calculate_stat(attr)
    return @template[attr] + @tunings[attr] if BASIC_ATTR.include? attr
    case attr
      when :bl
        basic_st = calculate_stat(:st)
        (basic_st * basic_st / 5).round
      when :hp
        calculate_stat(:st) + @tunings[:hp]
      when :wl
        calculate_stat(:iq) + @tunings[:wl]
      when :per
        calculate_stat(:iq) + @tunings[:per]
      when :fp
        calculate_stat(:ht) + @tunings[:fp]
      when :bsp
        (calculate_stat(:ht) + calculate_stat(:dx)) / 4 + @tunings[:bsp] * 0.25
      else
    end
  end

  def verify_stat(attr)
    stat_value = calculate_stat(attr)
    case
      when (attr == :wl || attr == :per) && (stat_value > 20 || stat_value < 4)
        result = false
      when attr == :fp
        ht = calculate_stat(:ht)
        result = (stat_value >= ht * 0.7) && (stat_value <= ht * 1.3)
      when attr == :bsp
        bsp = calculate_stat(:bsp)
        basic_stat = (calculate_stat(:ht) + calculate_stat(:dx)) / 4
        result = (basic_stat - bsp).abs <= 2.0
      else
        result = true
    end
    result
  end

  def calculate_points
    coeffs = { st: 10, ht: 10, dx: 20, iq: 20, hp: 2, wl: 5, per: 5, fp: 3, bsp: 5 }
    @points = coeffs.inject(powerlevel) { |acc, coeff|
      attr, val = coeff[0], coeff[1]
      acc - @tunings[attr] * val
    }
  end

  def effective_stats
    ALL_ATTR.inject({}) { |memo, stat|
      memo[stat] = calculate_stat(stat)
      memo
    }
  end

  def attr_change(attr, levels)
    @tunings[attr] += levels
    if verify_stat(attr)
      calculate_points
    else
      @tunings[attr] -= levels
    end
  end

end
