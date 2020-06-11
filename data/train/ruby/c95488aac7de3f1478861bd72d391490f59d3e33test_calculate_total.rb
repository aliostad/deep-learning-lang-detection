require 'minitest/autorun'
require 'minitest/colorize'
require './code'

class UnitPriceTest < Minitest::Unit::TestCase
  def test_empty
    assert_equal "$0.00", calculate_total([item_price: 0, item_quantity: 0])
  end
  def test_bob_marley
    assert_equal "$4.20", calculate_total([item_quantity: 2, item_price:2])
  end
  def test_2items
    assert_equal "$7.00", calculate_total([{item_quantity: 2, item_price: 2}, {item_quantity: 3, item_price: 0.89}])
  end
  def test_no_items
    assert_equal "$0.00", calculate_total([])
  end
  def test_no_argument
    assert_equal "$0.00", calculate_total()
  end
  def test_just_hash
    assert_equal "$5.25", calculate_total({item_quantity: 2, item_price: 2.5})
  end
  # I don't think this test is feasible because in order to pass 2 hashes seperated by a comma
  # the calculate_total needs to be modified to accept more than 1 argument
  def test_2_hash
    assert_equal "$13.65", calculate_total({item_quantity:1, item_price:3}, {item_quantity:2, item_price:5})
  end
end
