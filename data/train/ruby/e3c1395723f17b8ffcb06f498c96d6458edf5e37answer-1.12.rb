#!/usr/bin/ruby -w

require 'test/unit'

=begin
Ruby solution to SICP exercise 1.12
=end

class Pascal
  def self.calculate_node(row, col)
    if ( (col < 0) or (col > row) )
      0
    elsif ( (col == 0) or (col == row) )
      1
    else
      newrow = row - 1
      calculate_node(newrow, col-1) + calculate_node(newrow, col)
    end
  end
end

class TestPascal < Test::Unit::TestCase
  def test_calculate_node
    assert_equal(1, Pascal::calculate_node(0, 0))
    assert_equal(1, Pascal::calculate_node(1, 0))
    assert_equal(1, Pascal::calculate_node(1, 1))
    assert_equal(1, Pascal::calculate_node(2, 0))
    assert_equal(2, Pascal::calculate_node(2, 1))
    assert_equal(1, Pascal::calculate_node(2, 2))
    assert_equal(1, Pascal::calculate_node(3, 0))
    assert_equal(3, Pascal::calculate_node(3, 1))
    assert_equal(3, Pascal::calculate_node(3, 2))
    assert_equal(1, Pascal::calculate_node(3, 3))
    assert_equal(1, Pascal::calculate_node(4, 0))
    assert_equal(4, Pascal::calculate_node(4, 1))
    assert_equal(6, Pascal::calculate_node(4, 2))
    assert_equal(4, Pascal::calculate_node(4, 3))
    assert_equal(1, Pascal::calculate_node(4, 4))

    assert_equal(0, Pascal::calculate_node(4, 5))
  end
end

