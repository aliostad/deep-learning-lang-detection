require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'
require_relative 'invoice_item_repository'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'repository'
require 'pry'


class SalesEngine
  attr_reader :customer_repository, :invoice_repository,
              :transaction_repository, :invoice_item_repository,
               :merchant_repository, :item_repository, :csv_path

  def initialize(csv_path = our_folder)
    @csv_path = csv_path
  end

  def our_folder
    our_root = File.expand_path('../..',  __FILE__)
    File.join our_root, "data"
  end

  def repository_startup
    @customer_repository = CustomerRepository.new(self, csv_path)
    @invoice_repository = InvoiceRepository.new(self, csv_path)
    @transaction_repository = TransactionRepository.new(self, csv_path)
    @invoice_item_repository = InvoiceItemRepository.new(self, csv_path)
    @merchant_repository = MerchantRepository.new(self, csv_path)
    @item_repository = ItemRepository.new(self, csv_path)
  end

  def startup
    repository_startup
  end

end

engine = SalesEngine.new()
engine.startup
if __FILE__ == $0
  puts "Using csv folder.... #{engine.csv_path}"
  binding.pry
end
