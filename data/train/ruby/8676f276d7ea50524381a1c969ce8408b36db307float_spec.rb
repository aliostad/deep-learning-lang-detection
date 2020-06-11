describe Float do
  describe "#add" do
    it "should add the values" do
      expect(4.5.add(4.2)).to eq 8.7
    end
  end

  describe "#subtract" do
    it "should subtract the values" do
      expect(8.1.subtract(2)).to eq 6.1
    end
  end

  describe "#multiply_by" do
    it "should multiply the values" do
      expect(3.5.multiply_by(2)).to eq 7
    end
  end

  describe "#divide_by" do
    it "should divide the values" do
      expect(12.5.divide_by(2)).to eq 6.25
    end
  end

  describe "#calculate_input" do
    it "should calculate the values" do
      expect(3.5.calculate_input("+3")).to eq 6.5
    end
  end

  describe "#calculate" do
    it "returns a new Calculator instance with the result already set" do
      expect(4.5.calculate.add(2).result).to eq 6.5
    end
  end
end
