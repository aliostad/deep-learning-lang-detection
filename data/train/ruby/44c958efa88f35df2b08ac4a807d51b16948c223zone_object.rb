# encoding: utf-8

class ZoneObject

  WIDTH      = 80
  HEIGHT     = 75
  HORIZONTAL = 10
  VERTICAL   = 8

  attr_reader :window, :image, :index, :type

  def initialize(index, type)
    @index  = index
    @type   = type
    @image  = Gosu::Image.new(TheLegendOfRuby.window, "graphics/#{type}.png", false)
  end

  def draw
    @image.draw(
      calculate_x,
      calculate_y,
      1
    )
  end

  def calculate_x
    num = (index / HORIZONTAL)
    if num > 0
      ((index - (num * HORIZONTAL)) * WIDTH)
    else
      index * WIDTH
    end
  end

  def calculate_y
    num = (index / HORIZONTAL)
    num * HEIGHT
  end

end
