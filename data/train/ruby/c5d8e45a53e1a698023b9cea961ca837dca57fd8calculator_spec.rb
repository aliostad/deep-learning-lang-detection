$:.unshift File.join(File.dirname(__FILE__), *%w[.])
require 'calculator'

describe Calculator do

  it "should know that 1 + 1 = 2.0" do
    Calculator.calculate("1+1").should == 2.0
  end
  
  it "should know that 5.0 - 1.3 = 3.7" do
    Calculator.calculate("5.0 - 1.3").should == 3.7
  end

  it "should know that -12.3e-27 * 5 =  6.15e-26" do
    Calculator.calculate("-12.3e-27*5").should == -6.15e-26
  end

  it "should know that 1000/10 =  100" do
    Calculator.calculate("1000/10").should == 100
  end
  
  it "should know that (1+3)*(8*2) = 64" do
    Calculator.calculate("(1+3)*(8*2)").should == 64
  end
  
end
