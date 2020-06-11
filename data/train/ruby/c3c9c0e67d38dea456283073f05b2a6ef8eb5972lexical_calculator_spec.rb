require_relative '../lexical_calculator.rb'

describe LexicalCalculator do
  it "should have a calculate method" do
    expect(LexicalCalculator).to respond_to(:calculate)
  end

  it "should do math correctly" do
    expect(LexicalCalculator.calculate("12 + 33")).to be(45.to_f)
    expect(LexicalCalculator.calculate("12 - 33")).to be(-21.to_f)
    expect(LexicalCalculator.calculate("12 * 33")).to be(396.to_f)
    expect(LexicalCalculator.calculate("12 / 33")).to be(0.36363636363636365.to_f)
  end

  it "should be able to be called via the calc command" do
    expect(calc "12 * 33").to be(396.to_f)
  end
end
