require 'spec_helper'

describe Processor do
  let(:processor) { Processor.new }

  it "adds two numbers together" do
    expect(processor.calculate([3,1,"+"])).to eq 4.0
  end

  it "subtracts two numbers from each other" do
    expect(processor.calculate([9,4,"-"])).to eq 5.0
  end

  it "multiplies two numbers together" do
    expect(processor.calculate([9,4,"*"])).to eq 36.0
  end

  it "supports division of two numbers" do
    expect(processor.calculate([8,2,"/"])).to eq 4.0
  end

  it "displays NaN when trying to divide by 0" do
    expect(processor.calculate([0,0,"/"])).to be_nan  
  end

  describe "multiple operations" do
    it "supports multiple operations" do
      expect(processor.calculate([5,3,4,"-","*"])).to eq -5.0
    end

    it "supports even more multiple operations" do
      expect(processor.calculate([12,42,9,"*","-"])).to eq -366.0
    end
  end

end
