require './test/test_helper'

class TestEMA < Minitest::Test
  def setup
    ticker = "TESTING"
    @days = 90

    YahooFinance.stub(:get_historical_quotes, data_for_tests(@days)) do
      @stock = SignalTools::Stock.new(ticker)
    end

    @close_prices = @stock.stock_data.close_prices
  end

  def test_calculate
    assert_equal "2.344948", "%.6f" % SignalTools::Technicals::EMA.new(@close_prices, 10, :default).calculate[-1]
    assert_equal "2.736776", "%.6f" % SignalTools::Technicals::EMA.new(@close_prices, 10, :default).calculate[-5]
    assert_equal "2.556322", "%.6f" % SignalTools::Technicals::EMA.new(@close_prices, 25, :default).calculate[-1]
    assert_equal "2.705835", "%.6f" % SignalTools::Technicals::EMA.new(@close_prices, 25, :default).calculate[-5]
  end
end