require 'spec_helper'

describe Order do
  
  let(:order) { Order.new }
  
  describe "#calculate_charge" do
    it "calculates the correct charge" do
      order.delivery_distance = 2.5
      order.calculate_charge(order.delivery_distance).should eq(1200)
      
      order.delivery_distance = 2.99
      order.calculate_charge(order.delivery_distance).should eq(1200)
      
      order.delivery_distance = 3.15
      order.calculate_charge(order.delivery_distance).should be > 1200
      
      order.delivery_distance = 4.00
      order.calculate_charge(order.delivery_distance).should eq(1360)
    end
  end
end
