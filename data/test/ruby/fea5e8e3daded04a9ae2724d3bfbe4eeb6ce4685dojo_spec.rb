require 'spec_helper'
require_relative '../../lib/dojo'

describe Dojo do
  before (:all) do
    @dojo = Dojo.new
  end

  it "adds one and two" do
    expect(@dojo.calculate("+ 1 2")).to eq(3)
  end
  it "adds three and four" do
    expect(@dojo.calculate("+ 3 4")).to eq(7)
  end
  it "adds sixty and twenty" do
    expect(@dojo.calculate("+ 60 20")).to eq(80)
  end

  it "subtracts eight from twenty" do
    expect(@dojo.calculate("- 20 8")).to eq(12)
  end

  it "subtracts seven from nine" do
    expect(@dojo.calculate("- 9 7")).to eq(2)
  end
  it "subtracts twelve from seven" do
    expect(@dojo.calculate("- 7 12")).to eq(-5)
  end


  it "multiplies positive integers" do
    expect(@dojo.calculate("* 5 5")).to eq(25)
  end
  it "multiplies large integers" do
    expect(@dojo.calculate("* 10 500")).to eq(5000)
  end
  it "multiplies negative integers" do
    expect(@dojo.calculate("* -10 -50")).to eq(500)
  end

  
  it "divides positive integers" do
    expect(@dojo.calculate("/ 60 5")).to eq(12)
  end
  it "divides negative integers" do
    expect(@dojo.calculate("/ -10 -2")).to eq(5)
  end


  it "accepts between 2 and 10 arguments" do
    expect(@dojo.calculate("+ 10 2 1 4 5")).to eq(22)
  end

  it "calculate the modulus" do
    expect(@dojo.calculate("% 6 3")).to eq(0)
  end
end
