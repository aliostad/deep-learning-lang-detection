require 'minitest/autorun'
require 'minitest/pride'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'fibber'

class FibberTest < Minitest::Test

  def setup
    @fib = Fibber.new
  end

  def test_that_tests_work
    assert @fib.is_a? Object
  end

  def test_that_sequence_starts_with_zero_and_one
    assert_equal [0, 1], @fib.sequence
  end

  def test_that_calculate_accepts_an_argument
    skip
    assert_equal [0, 1], @fib.calculate(1)
  end

  def test_that_calculate_returns_an_array_the_size_of_the_number
    assert_equal 3, @fib.calculate(3).size
  end

  def test_that_next_number_is_a_one
    @fib.calculate(3)
    assert_equal [0, 1, 1], @fib.sequence
  end

  def test_that_it_can_calculate_four_numbers
    @fib.calculate(4)
    assert_equal [0, 1, 1, 2], @fib.sequence
  end

  def test_that_it_can_calculate_nine_numbers
    @fib.calculate(9)
    assert_equal [0, 1, 1, 2, 3, 5, 8, 13, 21], @fib.sequence
  end

  def test_that_it_can_return_one_number
    @fib.calculate(1)
    assert_equal [0], @fib.calculate(1)
  end
end

