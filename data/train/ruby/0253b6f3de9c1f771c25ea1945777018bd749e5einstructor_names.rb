class NameCalc

  def self.calculate(name)


  end

end


















gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

class InstructorTest < Minitest::Test
  def test_two_letters_multiplier_works
    assert_equal 4, NameCalc.calculate("ad")
    assert_equal 8, NameCalc.calculate("db")
  end

  def test_four_letter_words_works
    assert_equal 6, NameCalc.calculate("abc")
    assert_equal 24, NameCalc.calculate("bcd")
    assert_equal 24, NameCalc.calculate "cbd"
    refute_equal 24, NameCalc.calculate("dbc")
  end
