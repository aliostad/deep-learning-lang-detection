require 'test/unit'
require './calculate003'

class TestCalc < Test::Unit::TestCase
  
  def test_largest_prime_factor
    assert_equal 29, Calculate.largest_prime_factor(13195)
    assert_equal 5, Calculate.largest_prime_factor(10)
    assert_equal 13, Calculate.largest_prime_factor(26)
  end

  # def test_is_prime
  #   primes = [2, 3, 5, 7, 11, 13, 17, 19]
  #   non_primes = [1, 4, 6, 8, 9, 10, 14, 15, 16, 18, 20]
    
  #   assert primes.all? do |n|
  #     Calculate.is_prime?(n)
  #   end
  #   assert non_primes.all? do |n|
  #     !Calculate.is_prime?(n)
  #   end
  # end
end
