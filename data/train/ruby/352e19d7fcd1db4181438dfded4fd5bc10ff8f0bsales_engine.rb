require_relative 'merchant_repository'
require_relative 'transaction_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'customer_repository'
require_relative 'file_io'
require          'time'

class SalesEngine

  attr_reader :merchant_repository,
              :transaction_repository,
              :customer_repository,
              :invoice_item_repository,
              :item_repository,
              :invoice_repository,
              :file_path

  def initialize(file_path = "./data")
    @file_path                 = file_path
    @merchant_repository     ||= MerchantRepository.new(self)
    @customer_repository     ||= CustomerRepository.new(self)
    @transaction_repository  ||= TransactionRepository.new(self)
    @invoice_item_repository ||= InvoiceItemRepository.new(self)
    @item_repository         ||= ItemRepository.new(self)
    @invoice_repository      ||= InvoiceRepository.new(self)
  end

  def startup
    merchant_repository.read_data(FileIO.read_csv("#{file_path}/merchants.csv"))
    customer_repository.read_data(FileIO.read_csv("#{file_path}/customers.csv"))
    transaction_repository.
      read_data(FileIO.read_csv("#{file_path}/transactions.csv"))
    invoice_item_repository.
      read_data(FileIO.read_csv("#{file_path}/invoice_items.csv"))
    item_repository.read_data(FileIO.read_csv("#{file_path}/items.csv"))
    invoice_repository.read_data(FileIO.read_csv("#{file_path}/invoices.csv"))
  end

  def find_items_by_merchant_id(merchant_id)
    item_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_by_merchant_id(merchant_id)
    invoice_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_transactions_by_invoice_id(invoice_id)
    transaction_repository.find_all_by_invoice_id(invoice_id)
  end

  def find_invoice_items_by_invoice_id(invoice_id)
    invoice_item_repository.find_all_by_invoice_id(invoice_id)
  end

  def find_customer_by_customer_id(customer_id)
    customer_repository.find_by_id(customer_id)
  end

  def find_merchant_by_merchant_id(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_invoice_by_invoice_id(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_item_by_item_id(item_id)
    item_repository.find_by_id(item_id)
  end

  def find_invoice_items_by_item_id(item_id)
    invoice_item_repository.find_all_by_item_id(item_id)
  end

  def find_invoices_by_customer_id(customer_id)
    invoice_repository.find_all_by_customer_id(customer_id)
  end

  def create_invoice_items(items, new_invoice_id)
    invoice_item_repository.create_invoice_items(items, new_invoice_id)
  end

  def charge(payment_data, invoice_id)
    transaction_repository.charge(payment_data, invoice_id)
  end
end
