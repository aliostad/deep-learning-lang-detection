require 'test/unit'

def count_gallon(gallon)
  result = {}
  gallon -= result[1] = [gallon, 20].min
  gallon -= result[2] = [gallon, 40].min
  result[3] = gallon
  result
end


def calculate_price(gallon)
  gallon_count = count_gallon(gallon)
  gallon_count[1] * 90 + gallon_count[2] * 80 + gallon_count[3] * 75
end


class TestGallon < Test::Unit::TestCase

  def test_count_gallon
    assert_equal({1 => 10, 2 => 0, 3 => 0}, count_gallon(10))
    assert_equal({1 => 20, 2 => 10, 3 => 0}, count_gallon(30))
    assert_equal({1 => 20, 2 => 40, 3 => 10}, count_gallon(70))
  end

  def test_calculate_price
    assert_equal(1350, calculate_price(15))
    assert_equal(3000, calculate_price(35))
    assert_equal(6125, calculate_price(75))
    assert_equal(8000, calculate_price(100))
    assert_equal(7250, calculate_price(90))
  end
end
