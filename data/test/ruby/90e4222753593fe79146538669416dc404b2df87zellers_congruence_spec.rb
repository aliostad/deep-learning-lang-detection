require_relative '../lib/zellers_congruence'

RSpec.describe ZellersCongruence do
  context ".calculate" do
    it "returns 0 (Sat) for July 2000" do
      ZellersCongruence.calculate(07, 2000).should == 0
    end
    it "returns 1 (Sun) for January 1905" do
      ZellersCongruence.calculate(1, 1905).should == 1
    end
    it "returns 2 (Mon) for December 3000" do
      ZellersCongruence.calculate(12, 3000).should == 2
    end
    it "returns 3 (Tue) for August 1809" do
      ZellersCongruence.calculate(8, 1809).should == 3
    end
    it "returns 4 (Wed) for August 2001" do
      ZellersCongruence.calculate(8, 2012).should == 4
    end
    it "returns 5 (Thur) for May 3000" do
      ZellersCongruence.calculate(5, 3000).should == 5
    end
    it "returns 6 (Fri) for February 2002" do
      ZellersCongruence.calculate(2, 2002).should == 6
    end
  end
end
