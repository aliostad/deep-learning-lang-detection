require 'rspec'
require './calculate020'

describe Calculate do
  describe "sum_of_digits" do
    it "should calculate the sum of the individual digits of a number" do
      Calculate.sum_of_digits(4).should == 4
      Calculate.sum_of_digits(12).should == 3
      Calculate.sum_of_digits(456).should == 15
      Calculate.sum_of_digits(1200).should == 3
      Calculate.sum_of_digits(8989).should == 34
    end
  end

  describe "factorial" do
    it "should calculate the result of multiplying all numbers up to a specificed number together" do
      Calculate.factorial(0).should == 1
      Calculate.factorial(1).should == 1
      Calculate.factorial(4).should == 24
      Calculate.factorial(10).should == 3628800
    end
  end

  it "should be possible to calculate the sum of the digits of 10!" do
    Calculate.sum_of_digits(Calculate.factorial(10)).should == 27
  end
  
end
