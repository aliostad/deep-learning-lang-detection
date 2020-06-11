require 'csv'
require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'transaction_repository'


class SalesEngine
  attr_reader :customer_repository,
              :invoice_repository,
              :merchant_repository,
              :invoice_item_repository,
              :item_repository,
              :transaction_repository

  attr_accessor :filepath

  def initialize(filepath)
    @filepath = filepath
    @customer_repository =
      CustomerRepository.new("#{@filepath}/customers.csv", self)
    @invoice_repository =
      InvoiceRepository.new("#{@filepath}/invoices.csv", self)
    @merchant_repository =
      MerchantRepository.new("#{@filepath}/merchants.csv", self)
    @invoice_item_repository =
      InvoiceItemRepository.new("#{@filepath}/invoice_items.csv", self)
    @item_repository =
      ItemRepository.new("#{@filepath}/items.csv", self)
    @transaction_repository =
      TransactionRepository.new("#{@filepath}/transactions.csv", self)
  end


  def find_invoice_by_transaction(id)
    invoice_repository.find_by_id(id)
  end

  def find_merchant_by_item(id)
    merchant_repository.find_by_id(id)
  end

  def find_invoice_by_invoice_item(id)
    invoice_repository.find_by_id(id)
  end

  def find_item_by_invoice_item(id)
    item_repository.find_by_id(id)
  end

  def find_customer_by_invoice(id)
    customer_repository.find_by_id(id)
  end

  def find_merchant_by_invoice(id)
    merchant_repository.find_by_id(id)
  end

  #Collections

  def find_invoice_items_by_item(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_items_by_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_transactions_by_invoice(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_invoice_items_by_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_invoices_by_merchant(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def create_new_items_with_invoice_id(items, id, quantity)
    invoice_item_repository.create_new_invoice_items(items, id, quantity)
  end

  def new_charge(card_info, id)
    transaction_repository.new_charge(card_info, id)
  end

  def startup
  end
end
