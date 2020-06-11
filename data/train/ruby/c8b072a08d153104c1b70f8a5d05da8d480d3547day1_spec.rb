require_relative 'day1'

describe FloorCalculator do
  describe "calculate_floor" do
    let!(:fc) { FloorCalculator.new }

    it "calculates floors" do
      floor = fc.calculate_floor "(())"
      expect(floor).to eq 0
      floor = fc.calculate_floor "()()"
      expect(floor).to eq 0
      floor = fc.calculate_floor "((("
      expect(floor).to eq 3
      floor = fc.calculate_floor "(()(()(\n"
      expect(floor).to eq 3
      floor = fc.calculate_floor "))((((("
      expect(floor).to eq 3
      floor = fc.calculate_floor "))("
      expect(floor).to eq(-1)
      floor = fc.calculate_floor ")))"
      expect(floor).to eq(-3)
    end
  end
end
