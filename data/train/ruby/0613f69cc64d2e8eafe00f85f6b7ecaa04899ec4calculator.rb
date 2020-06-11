class Calculator

  def initialize(num1, num2, operation)
    @num1 = num1.to_i
    @num2 = num2.to_i
    @operation = operation
   end

   def print_result
   	"The #{@operation} of #{@num1} and #{@num2} is: #{@result}"
   end

end

class Addition < Calculator

	def calculate
		@result = @num1 + @num2
	end

end

class Substraction < Calculator

	def calculate
		@result = @num1 - @num2
	end

end

class Multiplication < Calculator

	def calculate
		@result = @num1 * @num2
	end

end

class Division < Calculator

	def calculate
		@result = @num1 / @num2
	end

end