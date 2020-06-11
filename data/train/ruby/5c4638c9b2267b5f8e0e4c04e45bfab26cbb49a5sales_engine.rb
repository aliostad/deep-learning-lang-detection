require './lib/merchant_repository'
require './lib/invoice_repository'
require './lib/invoice_item_repository'
require './lib/item_repository'
require './lib/transaction_repository'
require './lib/customer_repository'

class SalesEngine

  def initialize
    @merchant_repository = MerchantRepository.new(self)
    @invoice_repository = InvoiceRepository.new(self)
    @invoice_item_repository = InvoiceItemRepository.new(self)
    @item_repository = ItemRepository.new(self)
    @transaction_repository = TransactionRepository.new(self)
    @customer_repository = CustomerRepository.new(self)
  end

  def startup
    @merchant_repository.load
    @invoice_repository.load
    @invoice_item_repository.load
    @item_repository.load
    @transaction_repository.load
    @customer_repository.load
  end

  def find_all_items_by_merchant_id(merchant_id)
    @item_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_all_invoices_by_merchant_id(merchant_id)
    @invoice_repository.find_all_by_merchant_id(merchant_id)
  end

end
