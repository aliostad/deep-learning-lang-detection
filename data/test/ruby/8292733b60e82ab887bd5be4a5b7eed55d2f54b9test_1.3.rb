# encoding: utf-8
# The tests are written using the standard Ruby library Test::Unit.

require_relative '../1.3.rb'
require 'test/unit'

class TestCalculate < Test::Unit::TestCase
  def test_0
    assert_in_delta(0, calculate([0, 0, 0]), 0.0001)
  end

  def test_1
    assert_in_delta(1, calculate([1, 1, 1]), 0.0001)
  end

  def test_2_1
    assert_in_delta(2, calculate([2]), 0.0001)
  end

  def test_2_2
    assert_in_delta(2, calculate([2, 2]), 0.0001)
  end

  def test_2_3
    assert_in_delta(2, calculate([2, 2, 2]), 0.0001)
  end

  def test_2_4
    assert_in_delta(2, calculate([2, 2, 2, 2]), 0.0001)
  end

  def test_2_5
    assert_in_delta(2, calculate([2, 2, 2, 2, 2]), 0.0001)
  end

  def test_3_1
    assert_in_delta(3, calculate([3]), 0.0001)
  end

  def test_3_2
    assert_in_delta(3, calculate([3, 3]), 0.0001)
  end

  def test_3_3
    assert_in_delta(3, calculate([3, 3, 3]), 0.0001)
  end

  def test_4
    assert_in_delta(4, calculate([4, 4, 4]), 0.0001)
  end

  def test_5
    assert_in_delta(5, calculate([5, 5, 5]), 0.0001)
  end

  def test_6
    assert_in_delta(6, calculate([6, 6, 6]), 0.0001)
  end

  def test_7
    assert_in_delta(7, calculate([7, 7, 7]), 0.0001)
  end

  def test_8
    assert_in_delta(8, calculate([8, 8, 8]), 0.0001)
  end

  def test_9
    assert_in_delta(9, calculate([9, 9, 9]), 0.0001)
  end

  def test_10
    assert_in_delta(10.1736, calculate([13, 3, 27]), 0.0001)
  end
end
