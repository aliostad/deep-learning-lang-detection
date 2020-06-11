require_relative "customer_repository.rb"
require_relative "invoice_item_repository.rb"
require_relative "invoice_repository.rb"
require_relative "item_repository.rb"
require_relative "merchant_repository.rb"
require_relative "transaction_repository.rb"

class SalesEngine
  attr_reader :customer_repository,
              :invoice_item_repository,
              :invoice_repository,
              :item_repository,
              :merchant_repository,
              :transaction_repository

  def initialize(file_path = "./data")
    @file_path = file_path
    startup
  end

  def startup
    @customer_repository = CustomerRepository.new("#{@file_path}/customers.csv", self)
    @invoice_item_repository = InvoiceItemRepository.new("#{@file_path}/invoice_items.csv", self)
    @invoice_repository = InvoiceRepository.new("#{@file_path}/invoices.csv", self)
    @item_repository = ItemRepository.new("#{@file_path}/items.csv", self)
    @merchant_repository = MerchantRepository.new("#{@file_path}/merchants.csv", self)
    @transaction_repository = TransactionRepository.new("#{@file_path}/transactions.csv", self)
  end

  def favorite_customer(merchant)
    @merchant_repository.get_favorite_customer(merchant)
  end
end
