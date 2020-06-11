require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'invoiceitem_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'

class SalesEngine
  attr_reader :customer_repository,
              :invoice_repository,
              :invoice_item_repository,
              :item_repository,
              :merchant_repository,
              :transaction_repository,
              :filepath
  Paths = {
          crpath:   '../sales_engine/data/customers.csv',
          irpath:   '../sales_engine/data/invoices.csv',
          iirpath:  '../sales_engine/data/invoice_items.csv',
          itpath:   '../sales_engine/data/items.csv',
          mpath:    '../sales_engine/data/merchants.csv',
          tpath:    '../sales_engine/data/transactions.csv'
  }
  def initialize(filepath)
    @filepath = filepath
  end

  def startup
    @customer_repository     = CustomerRepository.new(self)
    @invoice_repository      = InvoiceRepository.new(self)
    @invoice_item_repository  = InvoiceItemRepository.new(self)
    @item_repository         = ItemRepository.new(self)
    @merchant_repository     = MerchantRepository.new(self)
    @transaction_repository  = TransactionRepository.new(self)
    customer_repository.load_data(opener(Paths[:crpath]))
    invoice_repository.load_data(opener(Paths[:irpath]))
    invoice_item_repository.load_data(opener(Paths[:iirpath]))
    item_repository.load_data(opener(Paths[:itpath]))
    merchant_repository.load_data(opener(Paths[:mpath]))
    transaction_repository.load_data(opener(Paths[:tpath]))
  end

  def opener(path)
    CSV.open(path, headers: true, header_converters: :symbol)
  end

  def find_items_by_merchant_id(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_merchant_id(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_customer_id(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_transactions_by_invoice_id(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_successful_transactions_by_invoice_id(id)
    transaction_repository.find_all_successful_by_invoice_id(id)
  end

  def find_invoice_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_customer_by_id(id)
    customer_repository.find_by_id(id)
  end

  def find_invoice_items_by_item_id(id)
    invoice_item_repository.find_all_by_item_id(id)
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

end
#
# se=SalesEngine.new(nil)
# se.startup
# puts se.customer_repository.customers.first.first_name
# puts se.invoice_repository.invoices.first.merchant_id
# puts se.invoice_item_repository.invoice_items.first.quantity
# puts se.item_repository.items.first.name
# puts se.merchant_repository.merchants.first.name
# puts se.transaction_repository.transactions.first.credit_card_number
