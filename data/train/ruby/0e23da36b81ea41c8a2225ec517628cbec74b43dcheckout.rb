class Checkout

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @basket_items = []
  end

  def scan(item)
    true if @basket_items << item
  end

  def total
    price = calculate_price
    discount = calculate_discount

    price - discount
  end

  private

  def calculate_price
    @basket_items.inject(0) { |sum, item| sum += item.price }
  end

  def calculate_discount
    initial = 0

    @pricing_rules.each do |pricing_rule|
      initial += pricing_rule.discount(@basket_items)
    end

    initial
  end
end
