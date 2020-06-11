class Merchant < RepositoryObject
  extend Forwardable

  attr_reader :id, :name, :created_at, :updated_at

  def_delegators :@repository, :invoice_repository, :item_repository

  def initialize(args = {})
    @repository = args[:repository]
    @id         = args[:id]
    @name       = args[:name]
    @created_at = args[:created_at]
    @updated_at = args[:updated_at]
  end

  def invoices
    invoice_repository.find_all_by_merchant_id(id)
  end

  def items
    item_repository.find_all_by_merchant_id(id)
  end
end
