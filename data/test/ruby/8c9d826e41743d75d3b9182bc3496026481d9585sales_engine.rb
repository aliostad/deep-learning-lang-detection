require_relative 'csv_parser'
require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'invoice_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'

class SalesEngine
  attr_accessor :filepath
  attr_reader(
    :customer_repository,
    :invoice_repository,
    :invoice_item_repository,
    :item_repository,
    :merchant_repository,
    :transaction_repository
  )

  def initialize(filepath)
    @filepath = filepath
  end

  def startup
    initialize_customer_repository
    initialize_invoice_repository
    initialize_invoice_item_repository
    initialize_item_repository
    initialize_merchant_repository
    initialize_transaction_repository
  end

  def initialize_customer_repository
    data = Parser.call("#{@filepath}/customers.csv")
    @customer_repository = CustomerRepository.new(data, self)
  end

  def initialize_invoice_item_repository
    data = Parser.call("#{@filepath}/invoice_items.csv")
    @invoice_item_repository = InvoiceItemRepository.new(data, self)
  end

  def initialize_invoice_repository
    data = Parser.call("#{@filepath}/invoices.csv")
    @invoice_repository = InvoiceRepository.new(data, self)
  end

  def initialize_item_repository
    data = Parser.call("#{@filepath}/items.csv")
    @item_repository = ItemRepository.new(data, self)
  end

  def initialize_merchant_repository
    data = Parser.call("#{@filepath}/merchants.csv")
    @merchant_repository = MerchantRepository.new(data, self)
  end

  def initialize_transaction_repository
    data = Parser.call("#{@filepath}/transactions.csv")
    @transaction_repository = TransactionRepository.new(data, self)
  end


  def find_items_by_merchant_id(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_merchant_id(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_transactions_by_invoice_id(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_invoice_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_customer_by_id(id)
    customer_repository.find_by_id(id)
  end

  def find_merchant_by_id(id)
    merchant_repository.find_by_id(id)
  end

  def find_invoice_by_id(id)
    invoice_repository.find_by_id(id)
  end

  def find_item_by_id(id)
    item_repository.find_by_id(id)
  end

  def find_invoice_items_by_item_id(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_invoices_by_customer_id(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def create_new_items_with_invoice_id(items, id, quantity)
    invoice_item_repository.create_new_invoice_items(items, id, quantity)
  end

  def new_charge(card_info, id)
    transaction_repository.new_charge(card_info, id)
  end
end
