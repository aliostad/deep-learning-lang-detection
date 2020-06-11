require 'rubygems'
require 'minitest/autorun'
require 'minitest/unit'

require 'roman_numeral_calculator'

class RomanNumeralCalculator
  public :break_number_into_parts, :convert_roman_to_numeric,
         :convert_numeric_to_roman

  attr_reader :input
end

class RomanNumeralCalculatorTest < MiniTest::Unit::TestCase

  def setup_instance input
    @rnc = RomanNumeralCalculator.new input
  end

  def test_class_calculate_string_input
    assert_equal 3,  RomanNumeralCalculator.calculate('III')
    assert_equal 38, RomanNumeralCalculator.calculate('XXXVIII')
  end

  def test_class_calculate_fixnum_input
    assert_equal 'II', RomanNumeralCalculator.calculate(2)
    assert_equal 'III', RomanNumeralCalculator.calculate(3)
    assert_equal 'X', RomanNumeralCalculator.calculate(10)
    #assert_equal 'IV', RomanNumeralCalculator.calculate(4)
  end

  def test_class_calculate_with_bad_input
    assert_raises ArgumentError do
      RomanNumeralCalculator.calculate "29"
    end

    assert_raises ArgumentError do
      RomanNumeralCalculator.calculate "2"
    end

    assert_raises ArgumentError do
      RomanNumeralCalculator.calculate "F"
    end
  end

  def test_init
    setup_instance 123
    assert_equal 123, @rnc.input
  end

  def test_break_number_into_parts
    setup_instance 123
    assert_equal [100, 20, 3], @rnc.break_number_into_parts

    setup_instance 1
    assert_equal [1], @rnc.break_number_into_parts

    setup_instance 22
    assert_equal [20, 2], @rnc.break_number_into_parts
  end

  def test_convert_roman_to_numeric
    setup_instance 'X'
    assert_equal 10, @rnc.convert_roman_to_numeric
  end

  def test_convert_numeric_to_roman
    setup_instance 22
    assert_equal 'XXII', @rnc.convert_numeric_to_roman

    setup_instance 522
    assert_equal 'DXXII', @rnc.convert_numeric_to_roman
  end

end

