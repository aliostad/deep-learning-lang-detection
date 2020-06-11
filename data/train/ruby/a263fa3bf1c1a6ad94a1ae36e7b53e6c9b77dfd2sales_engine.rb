require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/customer_repository'
require_relative '../lib/transaction_repository'

class SalesEngine
  attr_reader :merchant_repository,
              :item_repository,
              :invoice_repository,
              :invoice_item_repository,
              :customer_repository,
              :transaction_repository

  def initialize(data_path)
    @data_path = data_path
  end

  def startup
    @merchant_repository     = MerchantRepository.new(self, @data_path)
    @item_repository         = ItemRepository.new(self, @data_path)
    @invoice_repository      = InvoiceRepository.new(self, @data_path)
    @invoice_item_repository = InvoiceItemRepository.new(self, @data_path)
    @customer_repository     = CustomerRepository.new(self, @data_path)
    @transaction_repository  = TransactionRepository.new(self, @data_path)
  end

  # merchant relationships
  def find_items_for_merchant(merchant_id)
    item_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_for_merchant(merchant_id)
    invoice_repository.find_all_by_merchant_id(merchant_id)
  end

  # transaction relationships
  def find_invoice_for_transaction(id)
    invoice_repository.find_by_id(id)
  end
end
