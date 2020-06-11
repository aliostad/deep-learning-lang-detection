require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < MiniTest::Test

  def setup
    @engine = SalesEngine.new
  end

  def test_it_initializes
    assert_kind_of SalesEngine, @engine
  end

  def test_it_starts_up
    @engine.startup
    assert_kind_of CustomerRepository,    @engine.customer_repository
    assert_kind_of InvoiceRepository,     @engine.invoice_repository
    assert_kind_of InvoiceItemRepository, @engine.invoice_item_repository
    assert_kind_of ItemRepository,        @engine.item_repository
    assert_kind_of MerchantRepository,    @engine.merchant_repository
    assert_kind_of TransactionRepository, @engine.transaction_repository
  end

end
