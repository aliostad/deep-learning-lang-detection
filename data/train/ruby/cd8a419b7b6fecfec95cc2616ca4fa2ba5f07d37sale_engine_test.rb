require_relative 'test_helper'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :sales_engine
  def setup
    @sales_engine = SalesEngine.new(File.join(SalesEngine::DATA_PATH, 'fixtures'))
    @sales_engine.startup
  end

  def test_that_startup_creates_intances_of_repository
    assert_instance_of CustomerRepository, sales_engine.customer_repository
    assert_instance_of MerchantRepository, sales_engine.merchant_repository
    assert_instance_of ItemRepository, sales_engine.item_repository
    assert_instance_of InvoiceRepository, sales_engine.invoice_repository
    assert_instance_of InvoiceItemRepository, sales_engine.invoice_item_repository
    assert_instance_of TransactionRepository, sales_engine.transaction_repository
  end
end
