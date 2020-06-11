class Order < ActiveRecord::Base
  # belongs_to  :product we can remove this bc we deleted it from this table
  belongs_to  :user
  belongs_to  :product_option
  has_many    :carted_products
  has_many    :products, :through => :carted_products
  SALES_TAX = 0.09
  # validates :user_id, presence: true

  # validates :subtotal, numericality: true
  # validates :subtotal, numericality: { only_integer: true }
  # validates :subtotal, presence: true

  # validates :tax, numericality: true
  # validates :tax, numericality: { only_integer: true }
  # validates :tax, presence: true

  # validates :total, numericality: true
  # validates :total, numericality: { only_integer: true }
  # validates :total, presence: true

  # validates :status, acceptance: { accept: 'carted' }
  # validates :status, acceptance: { accept: 'purchased' }

  def calculate_subtotal
    subtotal = 0
    carted_products.each do |carted_product|
      subtotal += carted_product.calculate_price
    end
    subtotal
  end

  def calculate_tax
    SALES_TAX * calculate_subtotal
  end

  def calculate_total
    calculate_subtotal + calculate_tax
  end

end
