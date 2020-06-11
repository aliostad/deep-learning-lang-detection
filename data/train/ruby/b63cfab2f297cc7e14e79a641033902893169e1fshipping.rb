module BreadExpressHelpers
  module Shipping
    def calculate_cart_shipping
      weight = 0
      return weight if session[:cart].empty? # skip if cart empty...
      session[:cart].each do |item_id, quantity|
        info = {item_id: item_id, quantity: quantity}
        order_item = OrderItem.new(info)
        weight += order_item.quantity * order_item.item.weight
      end
      calculate_shipping_costs(weight)
    end

    def calculate_shipping_costs(weight, base=2.00)
      increment = calculate_shipping_increase(weight)
      cost = base + increment
    end

    def calculate_shipping_increase(total_weight, allowed=5, charge=0.25)
      return 0 if total_weight <= allowed
      extra = (total_weight - allowed).to_i
      increment = extra * charge
    end  
  end
end