require 'csv'
require_relative'../lib/csv_handler'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/customer_repository'
require_relative '../lib/transaction_repository'

class SalesEngine

  attr_accessor :merchant_repository, :invoice_repository, :item_repository, :dir,
              :invoice_item_repository, :customer_repository, :transaction_repository

  def initialize(dir="./data/")
    @dir = dir
    startup
  end

  def startup
    merchants            = CsvHandler.new("#{dir}merchants.csv")
    @merchant_repository = MerchantRepository.new(self, merchants.data)

    invoices             = CsvHandler.new("#{dir}invoices.csv")
    @invoice_repository  = InvoiceRepository.new(self, invoices.data)

    items                = CsvHandler.new("#{dir}items.csv")
    @item_repository     = ItemRepository.new(self, items.data)

    invoice_items            = CsvHandler.new("#{dir}invoice_items.csv")
    @invoice_item_repository = InvoiceItemRepository.new(self, invoice_items.data)

    customers            = CsvHandler.new("#{dir}customers.csv")
    @customer_repository = CustomerRepository.new(self, customers.data)

    transactions            = CsvHandler.new("#{dir}transactions.csv")
    @transaction_repository = TransactionRepository.new(self, transactions.data)
  end

  def find_items_by_merchant_id(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_merchant_id(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_all_transactions_by_invoice_id(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_all_invoice_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_customer_by_customer_id(id)
    customer_repository.find_by_id(id)
  end

  def find_merchant_by_merchant_id(id)
    merchant_repository.find_by_id(id)
  end

  def find_invoice_by_invoice_id(id)
    invoice_repository.find_by_id(id)
  end

  def find_item_by_item_id(id)
    item_repository.find_by_id(id)
  end

  def find_all_invoice_items_by_item_id(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_all_invoices_by_customer_id(id)
    invoice_repository.find_all_by_customer_id(id)
  end
end

