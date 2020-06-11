class SpaceAge
  attr_accessor :seconds

  EARTH_SECONDS_PER_YEAR = 31557600

  RATIOS_TO_EARTH = {
    :earth => 1.0,
    :mercury => 0.2408467,
    :venus => 0.61519726,
    :mars => 1.8808158,
    :jupiter => 11.862615,
    :saturn => 29.447498,
    :uranus => 84.016846,
    :neptune => 164.79132
  }

  def initialize(seconds)
    @seconds = seconds
  end

  def on_earth
    calculate_for(:earth)
  end

  def on_mercury
    calculate_for(:mercury)
  end

  def on_venus
    calculate_for(:venus)
  end

  def on_mars
    calculate_for(:mars)
  end

  def on_jupiter
    calculate_for(:jupiter)
  end

  def on_saturn
    calculate_for(:saturn)
  end

  def on_uranus
    calculate_for(:uranus)
  end

  def on_neptune
    calculate_for(:neptune)
  end

  private

  def calculate_for(planet)
    seconds_on_planet = EARTH_SECONDS_PER_YEAR * RATIOS_TO_EARTH[planet].to_f

    (@seconds / seconds_on_planet).round(2)
  end
end
