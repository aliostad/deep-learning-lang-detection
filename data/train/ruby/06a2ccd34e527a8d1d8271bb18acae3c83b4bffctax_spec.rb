require 'tax.rb'
require 'product.rb'

describe Tax do

  before (:all) do
    @tax = Tax.EMPTY
    @price = 10
    IMPORTED_RATE = 5
    BASIC_RATE = 10
    EXEMPT_RATE = 0
    @imported_tax = Tax.new(@tax, IMPORTED_RATE)
    @basic_tax = Tax.new(@tax, BASIC_RATE)
    @exempt_tax = Tax.new(@tax, EXEMPT_RATE)
  end

it "should add no tax for an unspecified tax type" do
    @tax.calculate_tax(@price).should == 0
  end

it "should calculate tax for a basic product" do
    @basic_tax.calculate_tax(@price).should == 1
  end

 it "should calculate tax for an imported product" do
    tax = Tax.new(@basic_tax, IMPORTED_RATE)
    tax.calculate_tax(@price).should == 1.5
  end

 it "should calculate tax for a product regardless of taxation order" do
    tax = Tax.new(@imported_tax, BASIC_RATE)
    tax.calculate_tax(@price).should == 1.5
  end

 it "should calculate tax for an imported, exempt product" do
    tax = Tax.new(@imported_tax, EXEMPT_RATE)
    tax.calculate_tax(@price).should == 0.5
  end



end
