require 'minitest/autorun'
require 'simple_calcu'

class CalculatorTest < Minitest::Test
  def test_addition
    assert_equal 5, SimpleCalcu::add(3, 2)
  end

  def test_subtraction
    assert_equal 7, SimpleCalcu::sub(8, 1)
  end

  def test_multiplication
    assert_equal 25, SimpleCalcu::mul(5, 5)
  end

  def test_division
    assert_equal 5, SimpleCalcu::div(10, 2)
    assert_equal 3.3333333333333335, SimpleCalcu::div(10.0, 3)
    assert_raises(ZeroDivisionError) { SimpleCalcu::div(10, 0) }
  end
  
  def test_calculator
    assert_equal 5, SimpleCalcu::calculate(2, "+", 3)
    assert_equal 8, SimpleCalcu::calculate(5, "+", 3)
    assert_equal 2, SimpleCalcu::calculate(5, "-", 3)
    assert_equal -1, SimpleCalcu::calculate(0, "-", 1)
    assert_equal 25, SimpleCalcu::calculate(5, "*", 5)
    assert_equal 44, SimpleCalcu::calculate(2, "*", 22)
    assert_equal 2, SimpleCalcu::calculate(4, "/", 2)
    assert_equal 2.5, SimpleCalcu::calculate(5.0, "/", 2)
  end
end