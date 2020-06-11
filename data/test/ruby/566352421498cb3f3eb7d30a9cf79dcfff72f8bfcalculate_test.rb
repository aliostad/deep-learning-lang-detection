require 'test/unit'
require_relative 'string/calculate'

class CalculateTest < Test::Unit::TestCase
  INFINITY = 1.0/0
  
  def test_addition
    assert_equal "1+5".calculate, 6
  end
  
  def test_subtraction
    assert_equal "6-1".calculate, 5
  end
  
  def test_multiplication
    assert_equal "6*2".calculate, 12
  end
  
  def test_division
    assert_equal "60/5".calculate, 12
  end
  
  def test_advanced_math
    assert_equal "15+35-5*5".calculate, 25
    assert_equal "5+10/2-8*4".calculate, -22
    assert_equal "16*12/6+67-12+20/5".calculate, 91
  end
  
  def test_floats
    assert_equal "15.5 + 12.7".calculate, 28.2
    assert_equal "7.24 - 4.12".calculate, 3.12
    assert_equal "4.5 * 3".calculate, 13.5
    assert_equal "5.5 / 11".calculate, 0.5
  end
  
  def test_zero_devision
    assert_equal "5 / 0".calculate, INFINITY
  end
  
  def test_short_version
    assert_equal "1+5".calc,                "1+5".calculate
    assert_equal "6-1".calc,                "6-1".calculate
    assert_equal "6*2".calc,                "6*2".calculate
    assert_equal "16*12/6+67-12+20/5".calc, "16*12/6+67-12+20/5".calculate
  end
  
  def test_problem_with_order
    assert_equal "10/1*2".calc, 20
  end
end


