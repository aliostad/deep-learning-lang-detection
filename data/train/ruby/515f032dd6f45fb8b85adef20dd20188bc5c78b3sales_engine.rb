require 'csv'

class Record
  attr_accessor :attributes
  def initialize(attributes)
    self.attributes = attributes
  end
end


class Merchant < Record
end

class Invoice < Record
end

class Item < Record
end

class InvoiceItem < Record
end

class Transaction < Record
end

class Customer < Record
  def first_name
    attributes[:first_name]
  end
end

class Repository
  def initialize(data_file)
    hashes = CSV.read data_file, headers: true, header_converters: :symbol
    @all = hashes.map { |hash| record_class.new hash.to_hash }
  end
end

class CustomerRepository < Repository
  def record_class
    Customer
  end

  def find_all_by_first_name(first_name)
    @all.select { |customer| customer.first_name == first_name }
  end
end

class MerchantRepository < Repository
  def record_class
    Merchant
  end
end

class InvoiceRepository < Repository
  def record_class
    Invoice
  end
end

class ItemRepository < Repository
  def record_class
    Item
  end
end

class InvoiceItemRepository < Repository
  def record_class
    InvoiceItem
  end
end

class TransactionRepository < Repository
  def record_class
    Transaction
  end
end

class SalesEngine
  def initialize(data_dir)
    @data_dir = data_dir
  end

  attr_accessor :customer_repository

  def startup
    @customer_repository      = CustomerRepository.new("#{@data_dir}/customers.csv")
    @merchant_repository      = MerchantRepository.new("#{@data_dir}/merchants.csv")
    @invoice_repository       = InvoiceRepository.new("#{@data_dir}/invoices.csv")
    @item_repository          = ItemRepository.new("#{@data_dir}/items.csv")
    @invoice_item_repository  = InvoiceItemRepository.new("#{@data_dir}/invoice_items.csv")
    @transaction_repository   = TransactionRepository.new("#{@data_dir}/transactions.csv")
  end
end
