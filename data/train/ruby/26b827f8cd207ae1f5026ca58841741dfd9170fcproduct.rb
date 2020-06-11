class Product
  attr_reader :name, :price

  def initialize(attributes)
    @name = attributes[:name]
    @price = attributes[:price]
    @imported = attributes[:imported] || false
  end

  def price_with_taxes
    (@price + self.total_taxes).round(2)
  end
  
  def total_taxes
    (self.basic_tax + self.imported_tax).round(2)
  end

  def imported_tax
    # Calculate 5% tax
    @imported ? self.calculate_tax(5) : 0
  end

  def basic_tax
    # Calculate 10% tax
    self.calculate_tax(10)
  end

  def calculate_tax(rate)
    # Calculate tax ammount:
    the_tax = (@price * rate) / 100.0

    # Round up tax to the nearest 0.05:
    (the_tax * 20).ceil / 20.0
  end
end
