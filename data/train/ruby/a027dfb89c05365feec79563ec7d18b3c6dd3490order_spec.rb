require 'order'

RSpec.configure do |config|
	config.expect_with :rspec do |c|
		c.syntax = [:should]
	end
end

describe "Orders" do
	it "should create an order" do
		o = Order.new(["test1", true, false, "pen", 534])
		o.should_not be_nil
	end

	it "should not create a product with no args" do
		o = Order.new(["test1", true, "pen", 534])
		o.name.should be_nil
		o.employee.should be_nil
		o.affiliate.should be_nil
		o.item.should be_nil
		o.amount.should be_nil
	end

	### Price < 100
	it "should calculate the right values for an employee, not affiliate, price < 100, not excempted" do
		o = Order.new(["RSpec User", true, false, "pen", 89])
		o.calculate.should == 62.3
	end

	it "should calculate the right values for an affiliate, not employee, price < 100, not excempted" do
		o = Order.new(["RSpec User", false, true, "pen", 90])
		o.calculate.should == 81.0
	end
	### ------------------------------------------------

	###  Price > 100
	it "should calculate the right values for an employee, not affiliate, price > 100, not excempted" do
		o = Order.new(["RSpec User", true, false, "pen", 534])
		o.calculate.should == 240.3
	end

	it "should calculate the right values for an affiliate, not employee, price > 100, not excempted" do
		o = Order.new(["RSpec User", false, true, "pen", 534])
		o.calculate.should == 347.1
	end
	### ------------------------------------------------

	### Excempted Item
	it "should calculate the right values for an employee, not affiliate, price < 100, excempted" do
		o = Order.new(["RSpec User", true, false, "chocolate", 90])
		o.calculate.should == 90.0
	end

	it "should calculate the right values for an affiliate, not employee, price > 100, not excempted" do
		o = Order.new(["RSpec User", false, true, "chocolate", 534])
		o.calculate.should == 534.0
	end
	### ------------------------------------------------

	### Customer older than 2 years
	it "should calculate the right values for an employee, not affiliate, price < 100, excempted" do
		o = Order.new(["tests", true, false, "pen", 90])
		o.calculate.should == 85.5
	end

	it "should calculate the right values for an affiliate, not employee, price > 100, not excempted" do
		o = Order.new(["tests", false, true, "pen", 534])
		o.calculate.should == 373.8
	end
	### ------------------------------------------------
end
