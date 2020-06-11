require_relative 'merchant_repository'
require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'invoice_repository'
require_relative 'item_repository'
require_relative 'transaction_repository'

class SalesEngine

  attr_reader :files_path

  def initialize(files_path = './data')
    @files_path = files_path
  end

  def startup
    customer_repository
    invoice_item_repository
    invoice_repository
    item_repository
    transaction_repository
    merchant_repository
  end

  def merchant_repository(filename = "#{files_path}/merchants.csv")
    @merchant_repository ||= MerchantRepo.new(filename, self)
  end

  def customer_repository(filename = "#{files_path}/customers.csv")
    @customer_repository ||= CustomerRepo.new(filename, self)
  end

  def invoice_item_repository(filename = "#{files_path}/invoice_items.csv")
    @invoice_item_repository ||= InvoiceItemRepo.new(filename, self)
  end

  def invoice_repository(filename = "#{files_path}/invoices.csv")
    @invoice_repository ||= InvoiceRepo.new(filename, self)
  end

  def item_repository(filename = "#{files_path}/items.csv")
    @item_repository ||= ItemsRepo.new(filename, self)
  end

  def transaction_repository(filename = "#{files_path}/transactions.csv")
    @transaction_repository ||= TransactionRepo.new(filename, self)
  end

end
