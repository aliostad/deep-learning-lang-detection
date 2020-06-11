require 'fibonacci'

describe "fibonacci generator" do
  before(:all) do
    @fib = Fibonacci.new
  end

  it "returns 1 for the first fibonacci number" do
    @fib.calculate(1).should eq 1
  end

  it "returns 1 for the second fibonacci number" do
    @fib.calculate(2).should eq 1
  end

  it "returns 2 for the third fibonacci number" do
    @fib.calculate(3).should eq 2
  end

  it "returns 5 for the fith fibonacci number" do
    @fib.calculate(5).should eq 5
  end

  it "returns 144 for the twelth fibonacci number" do
    @fib.calculate(12).should eq 144
  end

end
