class Increaser
  attr_accessor :composer, :scope, :amount

  def initialize(composer, scope)
    @composer          = composer
    @scope             = scope
    @amount            = 0
    @currency_demand   = composer.demand_methods[:increase][:currency]
    @percentage_demand = composer.demand_methods[:increase][:percentage]

    calculate_amount if @currency_demand.any?
  end

  def calculate_amount
    calculate_currency
    calculate_percentage

    composer.total = amount
  end

  def calculate_currency
    self.amount += @currency_demand.map do |method|
      scope.send(method) || 0
    end.reduce(:+)
  end

  def calculate_percentage
    @percentage_demand.each do |method|
      value = scope.send(method) || 0
      self.amount += (value.to_f / 100) * amount
    end
  end
end
