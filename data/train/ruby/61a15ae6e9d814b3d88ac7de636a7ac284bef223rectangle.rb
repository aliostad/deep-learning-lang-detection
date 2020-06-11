class Rectangle

  attr_accessor :length, :width
  attr_reader   :area, :perimeter

  def initialize length, width
    @length = length
    @width = width
    calculate
  end

  def calculate
    @area = (@length * @width)
    @perimeter = (@length * 2 + @width * 2)
  end

  def length= num
    @length = num
    calculate
  end

  def width= num
    @width = num
    calculate
  end

  def update length, width
    # is it OK to call the initialize method from inside the class?
    # any side effects? or is it just a normal method call.
    initialize length, width
    #@length = length
    #@width =  width
    #calculate
  end


end
