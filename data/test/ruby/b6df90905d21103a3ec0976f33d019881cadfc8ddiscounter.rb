class Discounter
  attr_accessor :composer, :scope

  def initialize(composer, scope)
    @composer          = composer
    @scope             = scope
    @currency_demand   = composer.demand_methods[:discount][:currency]
    @percentage_demand = composer.demand_methods[:discount][:percentage]

    calculate_amount if @currency_demand.any?
  end

  def calculate_amount
    calculate_currency
    calculate_percentage
  end

  def calculate_currency
    self.composer.total -= @currency_demand.map do |method|
      scope.send(method) || 0
    end.reduce(:+)
  end

  def calculate_percentage
    @percentage_demand.each do |method|
      value = scope.send(method) || 0
      self.composer.total -= (value.to_f / 100) * composer.total
    end
  end
end
