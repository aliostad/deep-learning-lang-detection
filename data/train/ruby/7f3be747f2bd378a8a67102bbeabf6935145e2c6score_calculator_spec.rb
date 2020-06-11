require 'spec_helper'

module Bowling
  describe ScoreCalculator do
    describe ".calculate" do
      it "sums all the hits the player has" do
        ScoreCalculator.calculate(open_throw).should eql(15)
      end

      it "sums the next ball when you get a spare" do
        ScoreCalculator.calculate(spare).should eql(26)
        ScoreCalculator.calculate(spare_double).should eql(34)
      end

      it "sums the next two ball when you get a strike" do
        ScoreCalculator.calculate(strike).should eql(29)
        ScoreCalculator.calculate(strike_double).should eql(44)
        ScoreCalculator.calculate(perfect_score).should eql(300)
      end
    end
  end
end
