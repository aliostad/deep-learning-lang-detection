# whats_my_bonus.rb

# Understand the problem
#   take a positive integer and a boolean, calculate the bonus for a given
#   salary. If true, bonus is half salary, if false, bonus is 0.
#   Input: positive integer (salary) and a boolean (bonus)
#   Output: integer
#
# Examples / Test Cases
#   puts calculate_bonus(2800, true) == 1400
#   puts calculate_bonus(1000, false) == 0
#   puts calculate_bonus(50000, true) == 25000
#   All tests should print true
#
# Data Structures
#   Input: positive integer (salary) and a boolean
#   Output: integer (bonus)
#
# Algorithm / Abstraction
#   bonus ? salary / 2 : 0

# Program
def calculate_bonus(salary, bonus)
  bonus ? (salary / 2) : 0
end

puts calculate_bonus(2800, true) == 1400
puts calculate_bonus(1000, false) == 0
puts calculate_bonus(50000, true) == 25000
