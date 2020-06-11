require "minitest/autorun"
require "zeller"

class TestZeller < MiniTest::Unit::TestCase

  def test_01a_Zellers_class_takes_two_arguments
    assert_raises(ArgumentError) do
      test1 = Zellers_congruence.calculate(2012)
    end
  end

  def test_02a_Zellers_class_days
    assert_equal 1, Zellers_congruence.calculate(1, 2012)
  end

  def test_02b_Zellers_class_days
    assert_equal 0, Zellers_congruence.calculate(9, 2012)
  end

  def test_02c_Zellers_class_days
    assert_equal 6, Zellers_congruence.calculate(6, 2012)
  end

end