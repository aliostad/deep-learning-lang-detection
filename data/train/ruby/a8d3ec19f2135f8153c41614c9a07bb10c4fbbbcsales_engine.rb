require 'csv'
require 'bigdecimal'
require 'bigdecimal/util'
require 'date'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'item_repository'
require_relative 'invoice_item_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'
require_relative 'generic_repo'
require_relative 'sales_finder'
require_relative 'sales_intelligence'
require 'byebug'

class SalesEngine
  include SalesFinder
  include SalesIntelligence
  attr_reader :merchant_repository, :invoice_repository, :item_repository, :invoice_repository, :invoice_item_repository, :customer_repository, :transaction_repository

  def initialize(file_path)
    @file_path = file_path
  end

  def startup
    @merchant_repository  = MerchantRepository.new("#{@file_path}/merchants.csv", Merchant, self)
    @invoice_repository = InvoiceRepository.new("#{@file_path}/invoices.csv", Invoice, self)
    @item_repository = ItemRepository.new("#{@file_path}/items.csv", Item, self)
    @invoice_item_repository = InvoiceItemRepository.new("#{@file_path}/invoice_items.csv", InvoiceItem, self)
    @customer_repository = CustomerRepository.new("#{@file_path}/customers.csv", Customer, self)
    @transaction_repository = TransactionRepository.new("#{@file_path}/transactions.csv", Transaction, self)
  end
end
