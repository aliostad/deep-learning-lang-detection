require 'pry'
require 'prime'

def calculate_triangular_number(number)
  counter = 0
  total = 0
  while counter <= number do
    total += counter
    counter += 1
  end
  return total
end

def calculate_number_of_divisors(number)
  divisors=1
  primes = Prime.prime_division(number)
  primes.each do |x|
    divisors *= x[1]+1
  end
  return divisors
end



number = 0
found = false
highest_divisors = 0

while found == false do
  number += 1 
  triangle = calculate_triangular_number(number)
  num_divisors = calculate_number_of_divisors(triangle)
  found = true if num_divisors > 500
end

puts triangle, num_divisors