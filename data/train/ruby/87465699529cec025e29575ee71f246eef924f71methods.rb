# def add_array_of_numbers(num_array)
#   result = 0
#   i = 0
#   while i < num_array.length
#   	puts "*" * 10
#     puts i
#     result += num_array[i]
#     puts "*" * 10
#     puts result
#     i += 1
#     puts "*" * 10
#     puts i
#     puts "END"
#   end
#   return result
# end

# number_array = [2, 3, 4, 5, 6]

# puts "Add all numbers in an array: #{add_array_of_numbers(number_array)}"




# Calculate two numbers, specify operation in the options_hash
# using case-when for the control flow
def calculate(num1, num2, **options_hash)
  result = case options_hash[:operation]
    when "Add"
      result = num1 + num2
      result.round(options_hash[:precision])
    when "Subtract" then "No Subtraction operation yet"
    else "Not defined"
  end
  return result
end

puts "Calculate with 'Add' option: #{calculate(6.1,7.8, {operation: 'Add', precision: 10})}"
puts "Calculate with 'Subtract' option: #{calculate(7,8, {operation: 'Subtract', precision: 2})}"
puts "Calculate with 'Multiply' option: #{calculate(7,8, {operation: 'Multiply', precision: 2})}"