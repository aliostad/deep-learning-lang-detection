require 'test/unit'
require './calculate004'

class TestCalculate < Test::Unit::TestCase

def test_largest_palindrome_product
  result = Calculate.largest_palindrome_product_of_two_numbers_with_x_digits(2)
  assert_equal 9009, result
end

def test_raises_exception_with_argument_of_1
  assert_raise(ArgumentError) { Calculate.largest_palindrome_product_of_two_numbers_with_x_digits(0) }
  assert_raise(ArgumentError) { Calculate.largest_palindrome_product_of_two_numbers_with_x_digits(1) }
  assert_raise(ArgumentError) { Calculate.largest_palindrome_product_of_two_numbers_with_x_digits(4) }
end

end