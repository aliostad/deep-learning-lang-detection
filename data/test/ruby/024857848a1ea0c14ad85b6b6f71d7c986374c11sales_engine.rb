require 'csv'
require_relative './merchant_repository'
require_relative './invoice_repository'
require_relative './item_repository'
require_relative './invoice_item_repository'
require_relative './customer_repository'
require_relative './transaction_repository'

class SalesEngine
  attr_reader :merchant_repository, :file_path,
              :invoice_repository, :item_repository,
              :invoice_item_repository, :transaction_repository,
              :customer_repository

  def initialize(file_path = "./data")
    @file_path = file_path
  end

  def startup
    merchant_repository
    invoice_repository
    item_repository
    customer_repository
    transaction_repository
    invoice_item_repository
  end

  def merchant_repository
    merchant_repository = MerchantRepository.load(self, "#{file_path}/merchants.csv")
  end

  def invoice_repository
    invoice_repository = InvoiceRepository.load(self, "#{file_path}/invoices.csv")
  end

  def item_repository
    item_repository = ItemRepository.load(self, "#{file_path}/items.csv")
  end

  def customer_repository
    customer_repository = CustomerRepository.load(self, "#{file_path}/customers.csv")
  end

  def transaction_repository
    transaction_repository = TransactionRepository.load(self, "#{file_path}/transactions.csv")
  end

  def invoice_item_repository
    invoice_item_repository = InvoiceItemRepository.load(self, "#{file_path}/invoice_items.csv")
  end

  def find_all_items_by_merchant_id(merchant_id)
    item_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_all_invoices_by_merchant_id(merchant_id)
    invoice_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_all_transactions_by_invoice_id(invoice_id)
    transaction_repository.find_all_by_invoice_id(invoice_id)
  end

  def find_all_invoice_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_all_customers_by_customer_id(id)
    customer_repository.find_by_id(id)
  end

  def find_invoice_item_by_item_id(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_item_by_merchant_id(id)
    merchant_repository.find_by_id(id)
  end

  def find_all_invoices_by_customer_id(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_by_item_id(item_id)
    item_repository.find_by_item_id(item_id)
  end

  def find_item(id)
    item_repository.find_by_id(id)
  end

  def find_invoice(id)
    invoice_item_repository.find_by_id(id)
  end

  def invoice
    invoice_repository.find_by_id(invoice_id)
  end

  def find_invoice_by_invoice_id(id)
    invoice_repository.find_by_invoice_id(id)
  end

  def find_merchant(id)
    merchant_repository.find_by_merchant_id(id)
  end

  def find_invoice_item(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

end

# if __FILE__ == $0
  # engine = SalesEngine.new("./data")
  # engine.startup
  # merchant = engine.merchant_repository.find_by_name("Kirlin, Jakubowski and Smitham")
  # puts merchant.items
# end
