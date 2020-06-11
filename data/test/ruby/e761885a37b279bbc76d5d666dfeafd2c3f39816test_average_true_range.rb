require './test/test_helper'

class TestAverageTrueRange < Minitest::Test
  def setup
    ticker = "TESTING"
    @days = 90

    YahooFinance.stub(:get_historical_quotes, data_for_tests(@days)) do
      @stock = SignalTools::Stock.new(ticker)
    end

    @stock_data = @stock.stock_data
  end

  def test_calculate
    assert_equal "3.195750", "%.6f" % SignalTools::Technicals::AverageTrueRange.new(@stock_data, 14).calculate[-1]
    assert_equal "3.438910", "%.6f" % SignalTools::Technicals::AverageTrueRange.new(@stock_data, 14).calculate[-5]
    assert_equal "3.208282", "%.6f" % SignalTools::Technicals::AverageTrueRange.new(@stock_data, 15).calculate[-1]
    assert_equal "3.434397", "%.6f" % SignalTools::Technicals::AverageTrueRange.new(@stock_data, 15).calculate[-5]
  end
end