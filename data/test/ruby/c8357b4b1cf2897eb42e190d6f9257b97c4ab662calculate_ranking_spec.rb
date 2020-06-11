require 'spec_helper'

describe CalculateRanking do
  let(:ranking) { FactoryGirl.build(:ranking) }
  let(:calculate_ranking) { CalculateRanking.instance }
  after { CalculateRanking.reset }

  describe "#calculate" do
    context "without previous" do
      it "calls normalize" do
        calculate_ranking.expects(:normalize).returns(ranking.value)
        calculate_ranking.calculate(ranking)
      end

      it "returns the average between current value and previous value" do
        curr_value = calculate_ranking.normalize(ranking.raw)
        calculate_ranking.calculate(ranking).should == curr_value
      end
    end

    context "with previous" do
      it "returns the average between current value and previous value" do
        2.times { FactoryGirl.create(:ranking, mother: ranking.mother) }
        ranking.save
        prev_value = ranking.previous.value
        curr_value = calculate_ranking.normalize(ranking.raw)

        calculate_ranking.calculate(ranking).should == (prev_value + curr_value) / 2
      end
    end
  end

  describe "#normalize" do
    it "returns a normalized value" do
      calculate_ranking.instance_variable_set("@max",100)
      calculate_ranking.instance_variable_set("@min",1)
      calculate_ranking.normalize(50).should == 49.5
    end
  end
end

