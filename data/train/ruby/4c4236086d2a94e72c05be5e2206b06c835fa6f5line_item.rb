class LineItem < ActiveRecord::Base

  validates :name, :qty, :price, presence: true

  belongs_to :sale

  before_save :calculate_sale_total
  before_save :calculate_cost_total
  after_save :update_sale
  after_destroy :update_sale

  def calculate_sale_total
    self.item_sale_total = self.qty * self.price
  end

  def calculate_cost_total
    item_cost = self.cost || 0
    self.item_cost_total = self.qty * item_cost
  end

  def update_sale
    sale = self.sale
    begin
      sale.calculate_cost && sale.calculate_amount
      sale.save
    end
  end
end
