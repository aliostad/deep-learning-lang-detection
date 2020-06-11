class Invoice < ActiveRecord::Base

  validates :price, presence: true

  before_save :calculate_sales_tax, :calculate_service_fee, :calculate_total

  private

    def calculate_sales_tax
      case state
      when 'CA'
        self.sales_tax = price * 0.1
      when 'FL'
        self.sales_tax = price * 0.07
      end
    end

    def calculate_service_fee
      self.service_fee = (price / 0.8) - price
    end

    def calculate_total
      self.total = price + self.sales_tax + self.service_fee
    end
end
