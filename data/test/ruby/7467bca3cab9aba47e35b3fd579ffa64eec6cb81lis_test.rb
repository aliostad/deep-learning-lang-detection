require 'minitest/autorun'
require_relative 'lis'

class TestLis < MiniTest::Unit::TestCase
  def test_empty_array
    assert_equal 0, calculate([])
  end

  def test_one_element
    assert_equal 1, calculate([4])
  end

  def test_two_elements_incremental
    assert_equal 2, calculate([1, 2])
  end

  def test_10_elements_incremental
    assert_equal 10, calculate([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  end

  def test_three_elements_first_not_incremental
    assert_equal 2, calculate([5, 1, 2])
  end

  def test_equal_numbers
    assert_equal 1, calculate([2, 2])
  end

  def test_two_elements_decremental
    assert_equal 1, calculate([2, 1])
  end

  def test_complex_case
    assert_equal 5, calculate([8, 9, 1, 2, 3, 4, 5, 1, 2])
  end

  def test_stress
    assert_equal 1_000_000, calculate((1..1_000_000).to_a)
  end
end