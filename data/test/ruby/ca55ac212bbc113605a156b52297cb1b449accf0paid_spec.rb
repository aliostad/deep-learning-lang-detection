require "paid"

describe "calculate" do 
  it "should calculate addition" do
    expect(calculate("1+2+5")).to eq 8
    expect(calculate("2+9+5")).to eq 16
  end

  it "should calculate subtraction" do
    expect(calculate("9-4-2")).to eq 3
    expect(calculate("9-7-2")).to eq 0
  end

  it "should calculate addition and subtraction" do
    expect(calculate("4+5-3")).to eq 6
    expect(calculate("5-4+3")).to eq 4
  end

  it "should calculate multiplication" do
    expect(calculate("1*3*2")).to eq 6
    expect(calculate("2*2*2")).to eq 8
  end

  it "should calculate division" do
    expect(calculate("9/3/1")).to eq 3
    expect(calculate("9/3/3")).to eq 1
  end

  it "should calculate both" do
    expect(calculate("9/3*2")).to eq 6
    expect(calculate("3*3/2")).to eq 4.5
  end

  it "should calculate all four with valid order of operations" do
    expect(calculate("5-4+3*2/1")).to eq 7
    expect(calculate("1+4*2-5/1")).to eq 4
  end
end
