# standard implementation

class Operation

  def compute(number)
    number * 5
  end

end

class Calculator
  attr_accessor :operation

  def initialize(operation)
    @operation = operation
  end

  def calculate(number)
    @operation.compute(number)
  end

end

# functional implementation

class Calculator_v2

  def initialize(operation)
    @operation = operation
  end

  def calculate(number)
    @operation.call(number)
  end

end

# passing a block implementation

class Calculator_v3

  def initialize(&codeblock)
    @operation = codeblock
  end

  def calculate(number)
    @operation.call(number)
  end

end


calculator = Calculator.new(Operation.new)

puts calculator.calculate(5)

calculator2 = Calculator_v2.new(lambda { |num| num * 5 })

puts calculator2.calculate(5)

calculator3 = Calculator_v3.new do |num|
  num * 5
end

puts calculator3.calculate(5)
