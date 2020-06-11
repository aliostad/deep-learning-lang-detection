require 'test/unit'
require 'app/calculator'

# quickfix for CTRL+B to work with subl2:
# "cmd": ["ruby", "-I ./../", "$file"], in Ruby.sublime-build
class TestCalculate < Test::Unit::TestCase

	def setup
		@calc = Calculator.new
	end

	def test_calculate_basicSum
		assert_equal 5, @calc.calculate("3+2")
	end

	def test_calculate_basicSum_MoreThanOneDigit
		assert_equal 23, @calc.calculate("11+12")
	end

	def test_calculate_withSomeSpacesInSum
		assert_equal 5, @calc.calculate(" 3 + 2")
	end

	def test_calculate_basicMultiplication
		assert_equal 10, @calc.calculate("2*5")
	end

	def test_calculate_basicMultiplication_MoreThanOneDigit
		assert_equal 100, @calc.calculate("20*5")
	end

	def test_calculate_emptyStringIsZero
		assert_equal 0, @calc.calculate("")
	end

	def test_calculate_nilStringIsZero
		assert_equal 0, @calc.calculate(nil)
	end

end
