#require 'test/unit'
require 'helper'
require 'zellers'

class TestZellers < Test::Unit::TestCase

  # Easy wins...

  def test_01_zellers_can_see_method
    assert Zellers.respond_to? :calculate
  end

  def test_02_instance_of_class
    zellers = Zellers.new
    assert_instance_of(Zellers, zellers)
  end

  # Birthdays for testing -------

  def test_03_nov_1981
    weekday = Zellers.calculate(11, 1981)
    assert_equal(1, weekday)
  end

  def test_04_feb_1982
    weekday = Zellers.calculate(2, 1982)
    assert_equal(2, weekday)
  end

  def test_05_feb_2013
    weekday = Zellers.calculate(2, 2013)
    assert_equal(6, weekday)
  end

  def test_06_may_1984
    weekday = Zellers.calculate(5, 1984)
    assert_equal(3, weekday)
  end

  # Edge Cases -------

  def test_07_feb_1800
    weekday = Zellers.calculate(2, 1800)
    assert_equal(0, weekday)
  end

  def test_08_nov_3000
    weekday = Zellers.calculate(11, 3000)
    assert_equal(0, weekday)
  end

  def test_09_feb_1803
    weekday = Zellers.calculate(2, 1803)
    assert_equal(3, weekday)
  end

  def test_010_mar_2015
    weekday = Zellers.calculate(3, 2015)
    assert_equal(1, weekday)
  end

  def test_11_mar_2014
    weekday = Zellers.calculate(3, 2014)
    assert_equal(0, weekday)
  end

  def test_12_dec_2012 #6 lines printed
    weekday = Zellers.calculate(12, 2012)
    assert_equal(0, weekday)
  end

  def test_13_feb_2015 #4 lines printed
    weekday = Zellers.calculate(2, 2015)
    assert_equal(1, weekday)
  end

  # Leap Year? -------

  def test_14_1981
    refute Zellers.leap_year?(1981)
  end

  def test_15_2008
    assert Zellers.leap_year?(2008)
  end

  def test_16_1800
    refute Zellers.leap_year?(1800)
  end

  def test_17_2800
    assert Zellers.leap_year?(2800)
  end
end
