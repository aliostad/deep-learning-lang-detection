require_relative '../lib/zellers_congruence'
RSpec.describe Zeller do
  context ".calculate" do
    it "returns Tuesday" do
      Zeller.calculate(7, 2014).should == 3
    end
    it "returns Sunday" do
      Zeller.calculate(12, 2013).should == 1
    end
    it "returns Thursday" do
      Zeller.calculate(8, 2013).should == 5
    end
    it "returns Saturday" do
      Zeller.calculate(12, 2012).should == 7
    end
    it "returns Tuesday in January" do
      Zeller.calculate(1, 2013).should == 3
    end
    it "returns Sunday in Februry" do
      Zeller.calculate(2, 2009).should == 1
    end

  end
end
