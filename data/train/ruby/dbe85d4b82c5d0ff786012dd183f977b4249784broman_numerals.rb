@numeral_string = ''

def calculate(integer, numeral_string, string_part, numeral_value, modulus = '0')
	if modulus.to_i > 0
		@numeral_string = numeral_string + string_part * ((integer % modulus) / numeral_value)
	else
		@numeral_string = numeral_string + string_part * (integer / numeral_value)
	end
end

puts 'Please enter an integer greater than zero:'
integer = gets.chomp.to_i

calculate(integer, @numeral_string, 'M', 1000		)
calculate(integer, @numeral_string, 'D', 500, 1000	)
calculate(integer, @numeral_string, 'C', 100, 500	)
calculate(integer, @numeral_string, 'L', 50,  100	)
calculate(integer, @numeral_string, 'X', 10,  50	)
calculate(integer, @numeral_string, 'V', 5,   10 	)
calculate(integer, @numeral_string, 'I', 1,   5 	)

puts
puts "Here is #{integer} as a roman numeral:"
puts @numeral_string