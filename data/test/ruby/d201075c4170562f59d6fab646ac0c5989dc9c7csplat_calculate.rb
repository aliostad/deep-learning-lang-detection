# Write three methods: add, subtract, caclulate.
# You should be able to add or subtract by calling calculate with parameters.

def add(*numbers)
  numbers.inject(0) { |sum, number| sum + number }
end

def subtract(*numbers)
  difference = numbers.shift
  numbers.each { |number| difference = difference - number }
  difference
end


def calculate(*numbers)
  # remove params from array, if necessary
  if numbers.last.is_a?(Hash)
    params = numbers.pop
  else
    params = {}
  end
  result = add(*numbers)
  result = add(*numbers) if params[:add]
  result = subtract(*numbers) if params[:subtract]
  result
end

puts calculate(1,2,3,4,5)
puts calculate(1,2,3,4,5,10, :add => true)
puts calculate(10,2,2,2,2, :subtract => true)
