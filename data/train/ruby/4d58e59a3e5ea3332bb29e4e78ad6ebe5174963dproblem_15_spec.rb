require 'spec_helper'

describe Problems::Problem15 do

  context "#calculate" do
    subject(:problem) {Problems::Problem15.new}

    it "returns 2 for a 1x1 grid" do
      expect(problem.calculate(1)).to eq 2
    end

    it "returns 6 for a 2x2 grid" do
      expect(problem.calculate(2)).to eq 6
    end

    it "returns 20 for a 3x3 grid" do
      expect(problem.calculate(3)).to eq 20
    end
  end

  context "#execute" do
    it "finds 137846528820 routes in a 20x20 grid" do
      expect(Problems::Problem15.execute).to eq 137846528820
    end
  end
end