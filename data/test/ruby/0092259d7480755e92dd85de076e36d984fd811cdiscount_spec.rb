require 'discount'

RSpec.configure do |config|
	config.expect_with :rspec do |c|
		c.syntax = [:should]
	end
end

describe "Discounts" do
	it "should create a discount" do
		u = User.new(["RSpec User", true, false])
		d = Discount.new([u, "foo", 100])
		d.should_not be_nil
	end

	### Price < 100
	it "should calculate the right values for an employee, not affiliate, price < 100, not excempted" do
		u = User.new(["RSpec User", true, false])
		d = Discount.new([u, "foo", 90])
		d.calculate.should == 30
	end

	it "should calculate the right values for an affiliate, not employee, price < 100, not excempted" do
		u = User.new(["RSpec User", false, true])
		d = Discount.new([u, "foo", 90])
		d.calculate.should == 10
	end
	### ------------------------------------------------

	###  Price > 100
	it "should calculate the right values for an employee, not affiliate, price > 100, not excempted" do
		u = User.new(["RSpec User", true, false])
		d = Discount.new([u, "foo", 590])
		d.calculate.should == 55
	end

	it "should calculate the right values for an affiliate, not employee, price > 100, not excempted" do
		u = User.new(["RSpec User", false, true])
		d = Discount.new([u, "foo", 550])
		d.calculate.should == 35
	end
	### ------------------------------------------------

	### Excempted Item
	it "should calculate the right values for an employee, not affiliate, price < 100, excempted" do
		u = User.new(["RSpec User", true, false])
		d = Discount.new([u, "chocolate", 90])
		d.calculate.should == 0
	end

	it "should calculate the right values for an affiliate, not employee, price > 100, not excempted" do
		u = User.new(["RSpec User", false, true])
		d = Discount.new([u, "chocolate", 550])
		d.calculate.should == 0
	end
	### ------------------------------------------------

	### Customer older than 2 years
	it "should calculate the right values for an employee, not affiliate, price < 100, excempted" do
		u = User.new(["tests", true, false])
		d = Discount.new([u, "bar", 90])
		d.calculate.should == 5
	end

	it "should calculate the right values for an affiliate, not employee, price > 100, not excempted" do
		u = User.new(["tests", false, true])
		d = Discount.new([u, "bar", 550])
		d.calculate.should == 30
	end
	### ------------------------------------------------
end
