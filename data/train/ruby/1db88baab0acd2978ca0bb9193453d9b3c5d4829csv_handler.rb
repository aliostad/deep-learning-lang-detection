require 'csv'

class CSVHandler

  # attr_accessor :customers_repository,
  #               :invoices_repository,
  #               :invoice_items_repository,
  #               :items_repository,
  #               :merchants_repository,
  #               :transactions_repository

  def initialize(filename)
    CSV.open(filename, headers: true, header_converters: :symbol)
  end



end


#       def startup(dir)
#         load_data(dir)
#       end
#       def startup_fixtures
#         load_data('./test/fixtures')
#       end
#       def load_data(path)
#         @customer_repository = CustomerRepository.new
#         @invoice_repository = InvoiceRepository.new
#         @invoice_item_repository = InvoiceItemRepository.new
#         @item_repository = ItemRepository.new
#         @merchant_repository = MerchantRepository.new
#         @transaction_repository = TransactionRepository.new
#       end
#
#       def load(file)
#         CSV.open(file, headers: true, header_converters: :symbol)
#       end
#       def save(file, row)
#         CSV.open(file, 'ab', headers: true, header_converters: :symbol) do |csv|
#           csv << row
#         end
#       end
#       private
#       def load_path_and_class(path, klass)
#         "#{path}/#{klass}s.csv"
#       end
#     end
#   end
# end
