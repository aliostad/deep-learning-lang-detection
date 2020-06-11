require_relative '../lib/pass1'

describe PrimeFactors do

  describe "self.calculate(number)" do

    it "returns [] when given 1" do
      expect(PrimeFactors.calculate(1)).to eq []
    end

    it "returns [2] when given 2" do
      expect(PrimeFactors.calculate(2)).to eq [2]
    end

    it "returns [2, 2] when given 4" do
      expect(PrimeFactors.calculate(4)).to eq [2, 2]
    end

    it "returns [2, 3] when given 6" do
      expect(PrimeFactors.calculate(6)).to eq [2, 3]
    end

    it "returns [3, 3] when given 9" do
      expect(PrimeFactors.calculate(9)).to eq [3, 3]
    end

  end

end
