gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :sales_engine
  def setup
    @sales_engine                         = SalesEngine.new
    sales_engine.merchant_repository      = Minitest::Mock.new
    sales_engine.invoice_repository       = Minitest::Mock.new
    sales_engine.item_repository          = Minitest::Mock.new
    sales_engine.invoice_item_repository  = Minitest::Mock.new
    sales_engine.customer_repository      = Minitest::Mock.new
    sales_engine.transaction_repository   = Minitest::Mock.new
  end
  def test_it_instantiates_repositories
    sales_engine = SalesEngine.new
    assert sales_engine.merchant_repository
    assert sales_engine.invoice_repository
    assert sales_engine.item_repository
    assert sales_engine.invoice_item_repository
    assert sales_engine.customer_repository
    assert sales_engine.transaction_repository
  end
  def test_it_delegates_startup_to_repository_load_files
    sales_engine.merchant_repository.expect(:load_file, nil, [])
    sales_engine.invoice_repository.expect(:load_file, nil, [])
    sales_engine.item_repository.expect(:load_file, nil, [])
    sales_engine.invoice_item_repository.expect(:load_file, nil, [])
    sales_engine.customer_repository.expect(:load_file, nil, [])
    sales_engine.transaction_repository.expect(:load_file, nil, [])
    sales_engine.startup
    sales_engine.merchant_repository.verify
    sales_engine.invoice_repository.verify
    sales_engine.item_repository.verify
    sales_engine.invoice_item_repository.verify
    sales_engine.customer_repository.verify
    sales_engine.transaction_repository.verify
  end

  def test_it_delegates_find_invoices_by_customer_to_invoice_repository
    sales_engine.invoice_repository.expect(:find_all_by_customer_id, nil, [1])
    sales_engine.find_invoices_by_customer(1)
    sales_engine.invoice_repository.verify
  end

  def test_it_delegates_find_invoice_to_invoice_repository
    sales_engine.invoice_repository.expect(:find_by_id, nil, [1])
    sales_engine.find_invoice(1)
    sales_engine.invoice_repository.verify
  end

  def test_it_delegates_find_invoice_items_by_item_to_invoice_item_repository
    sales_engine.invoice_item_repository.expect(:find_all_by_item_id, nil, [1])
    sales_engine.find_invoice_items_by_item(1)
    sales_engine.invoice_item_repository.verify
  end

  def test_it_delegates_find_merchant_to_merchant_repository
    sales_engine.merchant_repository.expect(:find_by_id, nil, [1])
    sales_engine.find_merchant(1)
    sales_engine.merchant_repository.verify
  end

  def test_it_delegates_find_invoice_to_invoice_repository
    sales_engine.invoice_repository.expect(:find_by_id, nil, [1])
    sales_engine.find_invoice(1)
    sales_engine.invoice_repository.verify
  end

  def test_it_delegates_find_item_to_item_repository
    sales_engine.item_repository.expect(:find_by_id, nil, [1])
    sales_engine.find_item(1)
    sales_engine.item_repository.verify
  end

  def test_it_delegates_find_transactions_by_invoice_to_transaction_repository
    sales_engine.transaction_repository.expect(:find_all_by_invoice_id, nil, [1])
    sales_engine.find_transactions_by_invoice(1)
    sales_engine.transaction_repository.verify
  end

  def test_it_delegates_find_invoice_items_by_invoice_to_invoice_item_repository
    sales_engine.invoice_item_repository.expect(:find_all_by_invoice_id, nil, [1])
    sales_engine.find_invoice_items_by_invoice(1)
    sales_engine.invoice_item_repository.verify
  end

  def test_it_delegates_find_items_by_invoice_to_invoice_item_repository

    sales_engine.invoice_item_repository.expect(:find_all_by_invoice_id, [], [1])
    sales_engine.find_items_by_invoice(1)
    sales_engine.invoice_item_repository.verify
  end

  def test_it_delegates_find_customer_to_customer_repository
    sales_engine.customer_repository.expect(:find_by_id, nil, [1])
    sales_engine.find_customer(1)
    sales_engine.customer_repository.verify
  end

  def test_it_delegates_find_items_by_merchant_to_the_item_repository
    sales_engine.item_repository.expect(:find_all_by_merchant_id, nil, [1])
    sales_engine.find_items_by_merchant(1)
    sales_engine.item_repository.verify
  end

  def test_it_delegates_find_invoices_by_merchant_to_the_invoice_repository
    sales_engine.invoice_repository.expect(:find_all_by_merchant_id, nil, [1])
    sales_engine.find_invoices_by_merchant(1)
    sales_engine.invoice_repository.verify
  end

  def test_it_can_create_an_invoice_item
    sales_engine.invoice_item_repository.expect(:create, nil, [1])
    sales_engine.create_invoice_item(1)
    sales_engine.invoice_item_repository.verify
  end

  def test_it_can_create_a_transaction
    sales_engine.transaction_repository.expect(:create,nil,[1])
    sales_engine.create_transaction(1)
    sales_engine.transaction_repository

  end
end
