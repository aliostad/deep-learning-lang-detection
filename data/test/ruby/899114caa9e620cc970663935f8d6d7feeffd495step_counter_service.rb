class StepCounterService
  attr_accessor :pressure_kpa

  def initialize(pressure)
    @pressure_kpa = pressure.to_i
  end

  def save
    StepCounter.create(date: Time.new, pressure: calculate_height, kind: calculate_kind)
  end

  private

  def calculate_kind
    if @pressure_kpa > 300 && @pressure_kpa <= 400
      0
    elsif @pressure_kpa > 400 && @pressure_kpa < 600
      1
    end
  end

  def calculate_height
    const = 0.001

    pressure_pascal = @pressure_kpa * 0.1
    pressure_newtons = pressure_pascal * 4.2
  end
end
