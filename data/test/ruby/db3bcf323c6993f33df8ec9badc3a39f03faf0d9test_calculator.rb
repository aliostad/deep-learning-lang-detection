require_relative 'helper'

module Holes

  class CalculatorTest < Test::Unit::TestCase

    def setup
      @calculator = Calculator.new
    end

    def test_one_hole
      assert_equal 1, @calculator.calculate('A')
      assert_equal 1, @calculator.calculate('D')
      assert_equal 1, @calculator.calculate('O')
    end

    def test_two_holes
      assert_equal 2, @calculator.calculate('B')
    end

    def test_zero_holes
      assert_equal 0, @calculator.calculate('C')
      assert_equal 0, @calculator.calculate('E')
    end

    def test_words
      assert_equal 10, @calculator.calculate('paralelepipedo')
      assert_equal 2,  @calculator.calculate('hello')
      assert_equal 5,  @calculator.calculate('this is spartaaa')
    end
  end
end
