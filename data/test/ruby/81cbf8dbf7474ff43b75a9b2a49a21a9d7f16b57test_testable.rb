require 'minitest/autorun'
require './testable.rb'

class TestTestableClass1 < Minitest::Test
  def setup
    @problem = TestableClass1.new
  end

  def test_testable_class_1_for_10
    assert_equal 10, @problem.calculate(10)
  end

  def test_testable_class_1_for_100
    assert_equal 100, @problem.calculate(100)
  end

  def test_testable_class_1_for_10_not_true
    refute_equal 100, @problem.calculate(10)
  end
end

class TestTestableClass2 < Minitest::Test
  def setup
    @problem = TestableClass2.new(3,5)
  end

  def test_problem_1_for_10
    assert_equal 23, @problem.calculate(10)
  end

  def test_problem_1_for_100
    assert_equal 2318, @problem.calculate(100)
  end

  def test_problem_1_for_1000
    assert_equal 233168, @problem.calculate(1000)
  end

  def test_testable_class_2_for_10_not_true
    refute_equal 24, @problem.calculate(10)
  end
end

class TestTestableClass3 < Minitest::Test
  def setup
    @problem = TestableClass3.new
  end

  def test_problem_6_for_10
    assert_equal 2640, @problem.calculate(10)
  end

  def test_problem_6_for_100
    assert_equal 25164150, @problem.calculate(100)
  end

  def test_problem_6_for_10_not_true
    refute_equal 2641, @problem.calculate(10)
  end
end

class TestTestableClass4 < Minitest::Test
  def setup
    @problem = TestableClass4.new
  end

  def test_testable_class_6_for_10
    assert_equal 55, @problem.calculate(10)
  end

  def test_testable_class_6_for_20
    assert_equal 6765, @problem.calculate(20)
  end

  def test_testable_class_6_for_10_not_true
    refute_equal 56, @problem.calculate(10)
  end
end