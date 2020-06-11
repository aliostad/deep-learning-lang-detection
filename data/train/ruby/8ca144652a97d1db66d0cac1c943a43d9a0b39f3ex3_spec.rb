require_relative '../ex3'
describe "Test Exercise 3" do
  context "calculate 4 maths with 1 number right" do
    it "add integer" do
      expect(calculate(2, :add)).to eq 2
    end

    it "add float" do
      expect(calculate(3.2, :add)).to eq 3.2
    end

    it "subtract integer" do
      expect(calculate(1, :sub)).to eq 1
    end

    it "subtract float" do
      expect(calculate(4.5, :sub)).to eq 4.5
    end

    it "multiple integer" do
      expect(calculate(2, :mul)).to eq 2
    end

    it "multiple float" do
      expect(calculate(3.2, :mul).round(1)).to eq 3.2
    end

    it "divide integer" do 
      expect(calculate(4, :div)).to eq 4
    end

    it "divide float" do
      expect(calculate(3.0, :div)).to eq 3.0
    end
  end

  context "calculate 4 maths with 2 numbers right" do
    it "add integer" do
      expect(calculate(1,2,:add)).to eq 3
    end

    it "add float" do
      expect(calculate(3.2, 4.2, :add)).to eq 7.4
    end

    it "subtract integer" do
      expect(calculate(1,2, :sub)).to eq -1
    end

    it "subtract float" do
      expect(calculate(4.5, 2.3, :sub)).to eq 2.2
    end

    it "multiple integer" do
      expect(calculate(2,3, :mul)).to eq 6
    end

    it "multiple float" do
      expect(calculate(3.2, 4.2, :mul).round(2)).to eq 13.44
    end

    it "divide integer" do 
      expect(calculate(4,5,:div)).to eq 0.8
    end

    it "divide float" do
      expect(calculate(3.0, 2.0, :div)).to eq 1.5
    end
  end

  context "calculate 4 maths with 3 numbers right" do
    it "add integer" do
      expect(calculate(1, 2, 3, :add)).to eq 6
    end

    it "add float" do
      expect(calculate(3.2, 4.2, 5.2, :add).round(1)).to eq 12.6
    end

    it "subtract integer" do
      expect(calculate(1, 2, 3, :sub)).to eq -4
    end

    it "subtract float" do
      expect(calculate(4.5, 2.5, 3.2, :sub).round(1)).to eq -1.2
    end

    it "multiple integer" do
      expect(calculate(2, 3, 4, :mul)).to eq 24
    end

    it "multiple float" do
      expect(calculate(3.2, 4.2, 5.2, :mul).round(3)).to eq 69.888
    end

    it "divide integer" do 
      expect(calculate(80, 4, 5, :div)).to eq 4
    end

    it "divide float" do
      expect(calculate(7.2, 2, 3, :div).round(1)).to eq 1.2
    end
  end

  context "wrong input check" do
    it "wrong first param" do
      expect(calculate("a", 3, :add)).to eq nil
    end

    it "wrong second param" do
      expect(calculate(3, "a", :add)).to eq nil
    end

    it "wrong third param" do
      expect(calculate(2, 3, "abc")).to eq nil
    end

    it "wrong all params" do 
      expect(calculate("a", "b", "c")).to eq nil
    end
  end
end
