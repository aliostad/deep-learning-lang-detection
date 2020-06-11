class Calculator
	attr_accessor :operator
	attr_accessor :val1
	attr_accessor :val2

	def input
		print "What is the operator?: "
		@operator = gets.chomp

		print "What is the first value?: "
		@val1 = gets.chomp.to_f

		print "What is the second value?: "
		@val2 = gets.chomp.to_f
	end

	def calculate
		case @operator
		when "+"
			return @val1 + @val2
		when "*"
			return @val1 * @val2
		when "/"
			return @val1 / @val2
		when "-"
			return @val1 - @val2
		else
			return "Invalid Operator"
		end
	end

	def output
		if self.calculate == "Invalid Operator"
			puts self.calculate
		else
			puts "#{@val1} #{@operator} #{@val2} = #{self.calculate}"
		end
	end
end

cal = Calculator.new
cal.input
cal.calculate
cal.output
