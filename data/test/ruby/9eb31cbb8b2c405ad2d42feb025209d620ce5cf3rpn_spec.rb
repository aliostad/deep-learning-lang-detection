$:.push File.join(File.dirname(__FILE__),'..','lib')
require 'rpncalc'
class RPNTest
  include Calculator
end

describe Calculator do
  before(:each) do
    @rpn = RPNTest.new
  end
  it "has can calculate many" do
    @rpn.calculate(5).should be 5
    @rpn.calculate(1).should be 1
    @rpn.calculate(2).should be 2
    @rpn.calculate('+').should be 3
    @rpn.calculate(4).should be 4
    @rpn.calculate('*').should be 12
    @rpn.calculate('+').should be 17
    @rpn.calculate(3).should be 3
    @rpn.calculate('-').should be 14

  end
it "has can calculate -" do
    @rpn.calculate(6).should be 6
    @rpn.calculate(5).should be 5
    @rpn.calculate('-').should be 1
  end
  it "has can calculate +" do
    @rpn.calculate(6).should be 6
    @rpn.calculate(5).should be 5
    @rpn.calculate('+').should be 11

  end
  it "has can calculate *" do
    @rpn.calculate(6).should be 6
    @rpn.calculate(5).should be 5
    @rpn.calculate('*').should be 30
  end
  it "has can calculate /" do
    @rpn.calculate(20).should be 20
    @rpn.calculate(10).should be 10
    @rpn.calculate('/').should be 2
    @rpn.calculate(6).should be 6
    @rpn.calculate(5).should be 5
    @rpn.calculate('/').should == 1.2
  end
end
