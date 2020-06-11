require_relative '../lib/zellers_congruence'

RSpec.describe ZellersCongruence do
  context ".calculate" do
    it "returns Saturday for March, 2015" do
      answer = ZellersCongruence.calculate(3, 2015)
      answer.should == 1
    end
    it "returns Wednesday for February, 2040" do
      answer = ZellersCongruence.calculate(2, 2040)
      answer.should == 4
    end
    it "returns Friday for February, 1901" do
      answer = ZellersCongruence.calculate(2, 1901)
      answer.should == 6
    end
    it "returns Monday for January, 1900" do
      answer = ZellersCongruence.calculate(1, 1900)
      answer.should == 2
    end
    it "returns Friday for February 2999" do
      answer = ZellersCongruence.calculate(2, 2999)
      answer.should == 6
    end
  end
end
