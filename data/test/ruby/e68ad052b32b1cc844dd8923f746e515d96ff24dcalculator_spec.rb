require 'spec_helper'
require 'calculator'

describe Calculator do
    it "tests basic operators" do
        Calculator.calculate("3+3").should == 6
        Calculator.calculate("3*3").should == 9
        Calculator.calculate("9/3").should == 3
        Calculator.calculate("9 - 3").should == 6
        Calculator.calculate("3^3").should == 27
        Calculator.calculate("-27").should == -27
        Calculator.calculate("1+(-27)").should == -26
    end
    it "tests order of operations" do
        Calculator.calculate("9-(4*8/2*(4+4))").should == -119
        Calculator.calculate("9-(4*8/2*4+4)").should == -59
        Calculator.calculate("9-4*8/2*4+4").should == -59
        Calculator.calculate("2*cos(0)*2").should == 4
        Calculator.calculate("2+cos(0)*2").should == 4
        Calculator.calculate("(2+cos(0))*2+tan(cos(0.5))*3").round(1).should == 9.6
        Calculator.calculate("8*log(100,10)+5").should == 21
        Calculator.calculate("8*sin(0)+5").should == 5
    end
    it "tests functions" do
        Calculator.calculate("sin(0)").should == 0
        Calculator.calculate("cos(0)").should == 1
        Calculator.calculate("tan(0)").should == 0
        Calculator.calculate("cos(0)*sin(3.14159/2)").round(0).should == 1
        Calculator.calculate("sqrt(16)").should == 4
        Calculator.calculate("log(100,10)").should == 2
    end
end
