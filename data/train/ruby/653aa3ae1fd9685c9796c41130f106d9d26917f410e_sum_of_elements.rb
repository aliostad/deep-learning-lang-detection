=begin
Exercise10. Write a Ruby program that, when given an array: collection = [1, 2, 3, 4, 5] calculates the sum of its elements.
=end
collection = [1, 2, 3, 4, 5]
=begin
puts 'Elements of collection: ',collection
puts 'Sum of the elements : ',collection.reduce(:+)
=end
=begin
Other solution
collection = [1, 2, 3, 4, 5]
def calculate_sum(array)
  sum = 0
  array.each do |e|
    sum = e + sum
  end
  return sum
end
puts calculate_sum(collection)
Another:
def calculate_sum(array)
array.reduce(:+)
end
if __FILE = $PROGRAM_NAME
puts calculate_sum([1, 2, 3, 4, 5])
end
=end
def calculate(collection)
  sum = 0
  for i in 0..4
    sum = sum + collection[i]
  end
  puts 'Sum of the elements : ',sum
end
calculate(collection)
