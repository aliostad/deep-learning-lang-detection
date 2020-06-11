class RPNCalculator

  attr_reader :value

  def initialize
    @numbers = []
  end

  def push value
    @numbers << value
  end

  def plus
    calculate "+"
  end

  def minus
    calculate "-"
  end

  def divide
    calculate "/"
  end

  def times
    calculate "*"
  end

  def tokens string
    string.split(' ').map do |val|
      (val =~ /\d+/) ? val.to_i : val.to_sym
    end
  end

  def evaluate string
    tokes = tokens string
    tokes.each { |val| interpret val }
    @value
  end

  private

    def enough?
      raise "calculator is empty" if @numbers.length == 0
      raise "not enough values" if @numbers.length == 1
    end

    def calculate operator
      enough?
      num1, num2 = @numbers.pop(2)
      @value = num1.to_f.send(operator, num2.to_f)
      @numbers << @value
    end

    def interpret val
      val.is_a?(Integer) ? push(val) : calculate(val)
    end

end
