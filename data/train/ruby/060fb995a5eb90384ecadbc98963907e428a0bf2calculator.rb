# CALCULATOR 

class Calculator
  def add(a,b)
    a + b
  end

  def subtract(a, b)
  	a - b
  end

  def multiply(a,b)
  	a * b
  end

  def divide(a,b)
  	a.to_f / b.to_f
  end

  def is_number(a,b)
    (a.is_a? Numeric) && (b.is_a? Numeric)
  end

  def result(answer)
    "The answer is #{answer}" 
  end

  def calculate(a,b, operation)
    if is_number(a,b) 
      case operation.downcase
      when "add"
        result( add(a,b) )
      when "subtract"
        result( subtract(a,b) )
      when "multiply"
        result( multiply(a,b) )
      when "divide"
        result( divide(a,b) )
      else
        "Sorry that's not a valid operation"
      end
    else
      "Please make sure to input numbers only"
    end
  end
end

c = Calculator.new
puts c.calculate(3,4,"Add")
puts c.calculate(3,4,"subtract")
puts c.calculate(3,4,"multiply")
puts c.calculate(3,4,"divide")
puts c.calculate(3,"4","Add")
puts c.calculate(3,4,"adddd")