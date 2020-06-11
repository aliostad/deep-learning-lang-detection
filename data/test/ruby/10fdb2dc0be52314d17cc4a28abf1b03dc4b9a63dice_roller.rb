class DiceRoller
  def initialize()
    @r = /(?<count>\d+)d(?<type>\d+)((?<sign>[+-])(?<modifier>\d+))?/
  end

  def roll(string)
    description = @r.match(string)
    raise if description == nil
    modifier = calculate_modifier(description[:sign], description[:modifier].to_i)
    value = calculate_value(description[:type].to_i, description[:count].to_i)
    [value + modifier, 0].max
  end

  def calculate_value(type, count)
    value = 0
    count.to_i.times do
      value += Kernel.rand(1..type)
    end
    value
  end

  def calculate_modifier(sign, modifier)
    sign = sign == '+' ? 1 : -1
    modifier = 0 if modifier == nil
    return modifier * (sign)

  end
end