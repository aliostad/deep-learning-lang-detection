require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'invoice_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'

class SalesEngine
  attr_reader :customer_repository, :invoice_item_repository,
              :invoice_repository, :item_repository,
              :merchant_repository, :transaction_repository,
              :filepath

  def initialize(filepath)
    @filepath = filepath
  end
  def startup
    customer_repository_load
    invoice_item_repository_load
    invoice_repository_load
    item_repository_load
    merchant_repository_load
    transaction_repository_load
  end

  def customer_repository_load
    @customer_repository ||= CustomerRepository.new("#{filepath}/customers.csv", self)
  end

  def invoice_item_repository_load
    @invoice_item_repository ||= InvoiceItemRepository.new("#{filepath}/invoice_items.csv", self)
  end

  def invoice_repository_load
    @invoice_repository ||= InvoiceRepository.new("#{filepath}/invoices.csv", self)
  end

  def item_repository_load
    @item_repository ||= ItemRepository.new("#{filepath}/items.csv", self)
  end

  def merchant_repository_load
    @merchant_repository ||= MerchantRepository.new("#{filepath}/merchants.csv", self)
  end

  def transaction_repository_load
    @transaction_repository ||= TransactionRepository.new("#{filepath}/transactions.csv", self)
  end

  def find_items_by_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_merchant(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_transactions_by_invoice(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_invoice_items_by_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_customer_by_invoice(customer_id)
    customer_repository.find_by_id(customer_id)
  end

  def find_merchant_by_invoice(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_invoice_by_invoice_item(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_item_by_invoice_item(item_id)
    item_repository.find_by_id(item_id)
  end

  def find_invoice_items_by_item(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_merchant_by_item(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_invoice_by_transaction(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_invoices_by_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_merchant_by_merchant_id(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_customer_by_customer_id(customer_id)
    customer_repository.find_by_id(customer_id)
  end

  def create_invoice_items(data, invoice_id)
    invoice_item_repository.create(data, invoice_id)
  end

  def create_transaction(input, invoice_id)
    transaction_repository.create(input, invoice_id)
  end
end
