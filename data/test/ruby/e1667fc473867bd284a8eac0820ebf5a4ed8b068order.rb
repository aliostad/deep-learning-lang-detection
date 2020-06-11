class Order < ActiveRecord::Base
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :street_name, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  # validates :zip, presence: true
  # validates :phone_number, presence: true
  # validates :email, presence: true
  # validates :shipping_preference, presence: true
  # validates :order_date, presence: true
  # validates :subtotal_in_cents, presence: true
  # validates :freight_in_cents, presence: true
  # validates :discount_in_cents, presence: true
  # validates :total_in_cents, presence: true

  enum status: [:open, :submitted, :shipped, :canceled]
  enum shipping_preference: [:ups_ground, :usps_ground]

  has_many :order_entries  
  belongs_to :user
  
  before_save :calculate_totals
  after_touch :update_totals

  def update_totals
    calculate_totals
    save
  end

  def has_address?
    address_1.present? && city.present? && state.present? && zip.present?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def calculate_totals
    self.subtotal_in_cents = calculate_subtotals
    self.freight_in_cents = calculate_freight
    self.discount_in_cents = calculate_discount
    self.tax_in_cents = calculate_tax
    self.total_in_cents = self.subtotal_in_cents + self.freight_in_cents + self.discount_in_cents + self.tax_in_cents
  end

  def calculate_subtotals
    order_entries.sum(:total_price_in_cents) || 0
  end

  def calculate_freight
    return 0 if self.subtotal_in_cents == 0
    
    [(ups_ground? ? 0.25 : 0.20) * self.subtotal_in_cents, 500].max

    # @active_shipping ||= ActiveShippingHelper.new(self)
    # @active_shipping.shipping_rates
  end

  def calculate_discount
    0
  end

  def calculate_tax
    begin
      @taxcloud = TaxcloudHelper.new(self)
      transaction = @taxcloud.transaction
      transaction.cart_items = @taxcloud.cart_items

      lookup = transaction.lookup
      lookup.tax_amount*100
    rescue
      0
    end
  end

end
