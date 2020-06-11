# class Fizzbuzz
# 	def calculate
# 		for num in (1..100) do
# 			if (num % 3).zero? && (num % 5).zero?
# 				num = 'FizzBuzz'
# 			elsif (num % 3).zero? 
# 				num = 'Fizz'
# 			elsif (num % 5).zero?
# 				num = 'Buzz'
# 			end
# 			puts num
# 		end
# 	end
# end

# start = Fizzbuzz.new.calculate

class Fizzbuzz
	def calculate
		for num in (1..100) do
			if (num % 3).zero? && (num % 5).zero?
				num = 'FizzBuzz'
			elsif (num % 3).zero? 
				num = 'Fizz'
			elsif (num % 5).zero?
				num = 'Buzz'
			end
			puts num
		end
	end
end

start = Fizzbuzz.new.calculate
				