require './test/test_helper'

class SalesEngineTest < Minitest::Test
  attr_reader :engine

  def setup
    @engine = SalesEngine.new
  end

  def test_merchant_repository_exists
    assert_equal MerchantRepository, engine.merchant_repository.class
  end

  def test_customer_repository_exists
    assert_equal CustomerRepository, engine.customer_repository.class
  end

  def test_transaction_repository_exists
    assert_equal TransactionRepository, engine.transaction_repository.class
  end

  def test_invoice_item_repository_exists
    assert_equal InvoiceItemRepository, engine.invoice_item_repository.class
  end

  def test_item_repository_exists
    assert_equal ItemRepository, engine.item_repository.class
  end

  def test_invoice_repository_exists
    assert_equal InvoiceRepository, engine.invoice_repository.class
  end
end
