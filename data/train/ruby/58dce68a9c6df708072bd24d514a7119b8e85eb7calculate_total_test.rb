require 'minitest/autorun'
require './calculate_total'

class UnitPriceTest < MiniTest::Unit::TestCase
  
  def test_empty_order
  	empty_array = []
  	assert_equal "$0.00", calculate_total(empty_array)
  end

  def test_one_item
  	array_of_one = [{:quantity => 2, :unit_price => 2.00}]
  	assert_equal "$4.20", calculate_total(array_of_one)
  end

  def test_two_items
  	array_of_two = [{:quantity => 2, :unit_price => 2.00}, {:quantity => 3, :unit_price => 0.89}]
  	assert_equal "$7.00", calculate_total(array_of_two)
  end

  def test_no_argument
  	assert_equal "$0.00", calculate_total
  end

  def test_variable_arguments
  	assert_equal "$7.00", calculate_total_var_args({:quantity => 2, :unit_price => 2.00}, {:quantity => 3, :unit_price => 0.89})
  end

end