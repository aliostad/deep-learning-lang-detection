require 'test/unit'
require 'q2/calculate_coins'

##
#
# This is a little test harness to call the protected
# methods within the CalculateCoins implementation
#
class CalculateCoinsProtectedHarness < Q2::CalculateCoins
  def call_biggest_index(money_value)
    self.biggest_index(money_value)
  end
end

class TestCalculateCoins < Test::Unit::TestCase

  def setup
    @calculate = CalculateCoinsProtectedHarness.new
  end

  def test_biggest_index_49
    result = @calculate.call_biggest_index(49)
    assert(result==4, "Result index was #{result}")
  end

end


