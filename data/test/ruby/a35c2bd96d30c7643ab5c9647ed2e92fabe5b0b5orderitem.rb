class Orderitem < ActiveRecord::Base
  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :order
  belongs_to :book

  before_save :finalize
  after_save :update_order_total_price
  after_destroy :update_order_total_price

  def calculate_unit_price
    if persisted?
      self.unit_price
    else
      book.price
    end
  end

  def calculate_price
    calculate_unit_price * quantity
  end

private
  def finalize
    self.unit_price = calculate_unit_price
    self.price = calculate_price
  end

  def update_order_total_price
    self.order.update_total_price
  end
end
