module Restaurant::Orders
  class CalculateIncome
    def initialize(restaurant, period = 1.week)
      @restaurant = restaurant
      @period = period
    end

    def call
      calculate_income
    end

    private

    attr_reader :restaurant, :period

    def finished_orders
      @orders ||= all_orders.paid.includes(:dishes, restaurant_sets: [:dishes])
    end

    def all_orders
      @restaurant.restaurant_orders.where('created_at >= ?', period.ago)
    end

    def calculate_income
      calculate_set_prices + calculate_dish_prices
    end

    def calculate_set_prices
      finished_orders.map(&:restaurant_sets).flatten.map do |set|
        set.dishes.map(&:price).inject(:+) * ((100 - set.discount) / 100)
      end.inject(:+) || 0
    end

    def calculate_dish_prices
      finished_orders.map(&:dishes).flatten.map(&:price).inject(:+) || 0
    end
  end
end
