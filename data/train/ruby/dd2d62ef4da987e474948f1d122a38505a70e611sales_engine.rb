require 'csv'
require_relative 'merchant'
require_relative 'merchant_repository'
require_relative 'invoice'
require_relative 'invoice_repository'
require_relative 'item'
require_relative 'item_repository'
require_relative 'invoice_item'
require_relative 'invoice_item_repository'
require_relative 'customer'
require_relative 'customer_repository'
require_relative 'transaction'
require_relative 'transaction_repository'


class SalesEngine

  attr_accessor :dir, :merchant_repository, :invoice_repository, :item_repository,
              :invoice_item_repository, :customer_repository, :transaction_repository

  def initialize(dir = "./csvs")
    @dir                      = dir
    @merchant_repository      = MerchantRepository.new(self, "#{dir}/merchants.csv")
    @invoice_repository       = InvoiceRepository.new(self, "#{dir}/invoices.csv")
    @item_repository          = ItemRepository.new(self, "#{dir}/items.csv")
    @invoice_item_repository  = InvoiceItemRepository.new(self, "#{dir}/invoice_items.csv")
    @customer_repository      = CustomerRepository.new(self, "#{dir}/customers.csv")
    @transaction_repository   = TransactionRepository.new(self, "#{dir}/transactions.csv")
  end
  def startup
    #puts "starting up cap'n"
    merchant_repository.load_file
    invoice_repository.load_file
    item_repository.load_file
    invoice_item_repository.load_file
    customer_repository.load_file
    transaction_repository.load_file
  end
  def find_invoices_by_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end
  def find_invoice(id)
    invoice_repository.find_by_id(id)
  end
  def find_invoice_items_by_item(id)
    invoice_item_repository.find_all_by_item_id(id)
  end
  def find_merchant(id)
    merchant_repository.find_by_id(id)
  end
  def find_invoice(id)
    invoice_repository.find_by_id(id)
  end
  def find_item(id)
    item_repository.find_by_id(id)
  end
  def find_transactions_by_invoice(id)
    transaction_repository.find_all_by_invoice_id(id)
  end
  def find_invoice_items_by_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end
  def find_items_by_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id).map do |invoice_item|
      item_repository.find_by_id(invoice_item.item_id)
    end
  end
  def find_customer(id)
    customer_repository.find_by_id(id)
  end
  def find_items_by_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end
  def find_invoices_by_merchant(id)
    invoice_repository.find_all_by_merchant_id(id)
  end
  def create_invoice_item(input)
    invoice_item_repository.create(input)
  end

  def create_transaction(input)
    transaction_repository.create(input)
  end
end
