gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'

require_relative 'merchant_repository'
require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'transaction_repository'



class SalesEngine

  attr_reader :dir

  def initialize(dir = './data')
    @dir = dir
    startup
  end

  def startup
    invoice_repository 
    merchant_repository
    customer_repository
    item_repository
    invoice_item_repository
    transaction_repository
  end

  def merchant_repository
    MerchantRepository.new("#{dir}/merchants.csv", self)
  end

  def customer_repository 
    CustomerRepository.new("#{dir}/customers.csv", self)
  end

  def invoice_repository
    InvoiceRepository.new("#{dir}/invoices.csv", self)
  end

  def item_repository
    ItemRepository.new("#{dir}/items.csv", self)
  end

  def invoice_item_repository
    InvoiceItemRepository.new("#{dir}/invoice_items.csv", self)
  end

  def transaction_repository
    TransactionRepository.new("#{dir}/transactions.csv", self)
  end


end







