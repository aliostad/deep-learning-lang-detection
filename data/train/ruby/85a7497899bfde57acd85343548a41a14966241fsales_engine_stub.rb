require './lib/sales_engine'

class SalesEngineStub < SalesEngine

  attr_reader :customer_repository, :invoice_repository,
              :invoice_item_repository, :item_repository, :merchant_repository,
              :transaction_repository
  def startup
    @customer_repository     ||= CustomerRepository.new(self, "./test/fixtures/customers.csv")
    @invoice_repository      ||= InvoiceRepository.new(self, "./test/fixtures/invoices.csv")
    @invoice_item_repository ||= InvoiceItemRepository.new(self, "./test/fixtures/invoice_items.csv")
    @item_repository         ||= ItemRepository.new(self, "./test/fixtures/items.csv")
    @merchant_repository     ||= MerchantRepository.new(self, "./test/fixtures/merchants.csv")
    @transaction_repository  ||= TransactionRepository.new(self, "./test/fixtures/transactions.csv")
  end

end
