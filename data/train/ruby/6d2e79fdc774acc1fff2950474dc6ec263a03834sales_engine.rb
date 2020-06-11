require_relative './sales_engine_requires'

class SalesEngine

  attr_accessor :filepath,
                :merchant_repository,
                :customer_repository,
                :invoice_repository,
                :item_repository,
                :invoice_item_repository,
                :transaction_repository

  def initialize(filepath)
    @filepath = filepath
  end

  def startup
    initialize_merchant_repository
    initialize_customer_repository
    initialize_item_repository
    initialize_invoice_repository
    initialize_invoice_item_repository
    initialize_transaction_repository
  end

  def initialize_merchant_repository
    data = MerchantParser.new("#{@filepath}/merchants.csv")
    @merchant_repository = MerchantRepository.new(data.merchants, self)
  end

  def initialize_customer_repository
    data = CustomerParser.new("#{@filepath}/customers.csv")
    @customer_repository = CustomerRepository.new(data.customers, self)
  end

  def initialize_item_repository
    data = ItemParser.new("#{@filepath}/items.csv")
    @item_repository = ItemRepository.new(data.items, self)
  end

  def initialize_invoice_repository
    data = InvoiceParser.new("#{@filepath}/invoices.csv")
    @invoice_repository = InvoiceRepository.new(data.invoices, self)
  end

  def initialize_invoice_item_repository
    data = InvoiceItemParser.new("#{@filepath}/invoice_items.csv")
    @invoice_item_repository = InvoiceItemRepository.new(data.invoice_items,
                                                         self
                                                         )
  end

  def initialize_transaction_repository
    data = TransactionParser.new("#{@filepath}/transactions.csv")
    @transaction_repository = TransactionRepository.new(data.transactions,
                                                        self
                                                        )
  end

end
