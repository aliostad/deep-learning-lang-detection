require 'csv'
require_relative 'merchant_repository'
require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'
require_relative 'file_loader'

class SalesEngine

  attr_reader :filepath,
              :customer_repository,
              :merchant_repository,
              :invoice_item_repository,
              :invoice_repository,
              :item_repository,
              :transaction_repository

  def initialize(filepath)
    @filepath = filepath
  end

  def startup
    @customer_repository = CustomerRepository.new(self)
    @merchant_repository = MerchantRepository.new(self)
    @invoice_item_repository = InvoiceItemRepository.new(self)
    @invoice_repository = InvoiceRepository.new(self)
    @item_repository = ItemRepository.new(self)
    @transaction_repository = TransactionRepository.new(self)

    @customer_repository.parse_data("#{@filepath}/customers.csv")
    @merchant_repository.parse_data("#{@filepath}/merchants.csv")
    @invoice_item_repository.parse_data("#{@filepath}/invoice_items.csv")
    @invoice_repository.parse_data("#{@filepath}/invoices.csv")
    @item_repository.parse_data("#{@filepath}/items.csv")
    @transaction_repository.parse_data("#{@filepath}/transactions.csv")
  end

  def invoice_find_customer_by_customer_id(id)
    @customer_repository.find_by_id(id)
  end

  def invoice_find_all_transactions_by_id(id)
    @transaction_repository.find_all_by_invoice_id(id)
  end

  def invoice_find_all_invoice_items_by_id(id)
    @invoice_item_repository.find_all_by_invoice_id(id)
  end

  def invoice_find_merchant_by_id(id)
    @merchant_repository.find_by_id(id)
  end

  def merchant_find_item_by_id(id)
    @item_repository.find_all_by_merchant_id(id)
  end

  def merchant_find_invoice_by_id(id)
    @invoice_repository.find_all_by_merchant_id(id)
  end

  def invoice_item_find_invoice_by_invoice_id(id)
    @invoice_repository.find_by_id(id)
  end

  def find_invoices_by_customer_id(id)
    @invoice_repository.find_all_by_customer_id(id)
  end

  def merchant_find_invoice_by_id(id)
    @invoice_repository.find_all_by_merchant_id(id)
  end

  def invoice_item_find_invoice_by_invoice_id(id)
    @invoice_repository.find_by_id(id)
  end

  def invoice_item_find_item_by_item_id(id)
    @item_repository.find_by_id(id)
  end

  def customer_find_invoices_by_customer_id(id)
    @invoice_repository.find_all_by_customer_id(id)
  end

  def item_find_invoice_items_by_item_id(id)
    @invoice_item_repository.find_all_by_item_id(id)
  end

  def item_find_merchant_by_merchant_id(id)
    @merchant_repository.find_by_id(id)
  end

  def transaction_find_invoice_by_invoice_id(id)
    @invoice_repository.find_by_id(id)
  end

  def successful_transactions_from_invoice_id(id)
    if invoice_find_all_transactions_by_id(id).nil?
      false
    else
      invoice_find_all_transactions_by_id(id).any? do |trans|
        trans.result == "success"
      end
    end
  end

  def create_transaction(input, id)
    @transaction_repository.create_transaction(input, id)
  end

end
