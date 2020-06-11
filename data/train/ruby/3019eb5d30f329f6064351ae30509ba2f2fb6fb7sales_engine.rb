require 'bigdecimal'
require 'csv'
require 'date'
require 'pry'
require_relative 'customer'
require_relative 'invoice'
require_relative 'invoice_item'
require_relative 'item'
require_relative 'merchant'
require_relative 'transaction'
require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'transaction_repository'
require_relative 'merchant_repository'

class SalesEngine
  attr_reader :invoice_repository,
              :item_repository,
              :merchant_repository,
              :customer_repository,
              :invoice_item_repository,
              :transaction_repository

  def initialize
    startup
  end

  def startup
    @invoice_repository      = InvoiceRepository.new(nil, self)
    @item_repository         = ItemRepository.new(nil, self)
    @invoice_item_repository = InvoiceItemRepository.new(nil, self)
    @customer_repository     = CustomerRepository.new(nil, self)
    @transaction_repository  = TransactionRepository.new(nil, self)
    @merchant_repository     = MerchantRepository.new(nil, self)
  end

end
