require_relative "csv_reader"
require_relative "merchant_repository"
require_relative "invoice_repository"
require_relative "item_repository"
require_relative "invoice_item_repository"
require_relative "customer_repository"
require_relative "transaction_repository"

class SalesEngine
  attr_reader :merchant_repository, :invoice_repository, :item_repository,
              :invoice_item_repository, :customer_repository, :transaction_repository

  def initialize(csv_directory)
    @csv_directory = csv_directory
  end

  def startup
    create_repos
  end

  private

  def create_repos
    @merchant_repository     = MerchantRepository.new(CSVReader, @csv_directory, self)
    @invoice_repository      = InvoiceRepository.new(CSVReader, @csv_directory, self)
    @item_repository         = ItemRepository.new(CSVReader, @csv_directory, self)
    @invoice_item_repository = InvoiceItemRepository.new(CSVReader, @csv_directory, self)
    @customer_repository     = CustomerRepository.new(CSVReader, @csv_directory, self)
    @transaction_repository  = TransactionRepository.new(CSVReader, @csv_directory, self)
  end
end
