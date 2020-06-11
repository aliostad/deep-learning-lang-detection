def calculate(expr)
  return `echo '#{expr}' | ./calc`.strip.to_i
end

describe "addition" do
  it "adds two numbers" do
    calculate("1 + 2").should == 3
    calculate("2 + 3").should == 5
    calculate("0 + 0").should == 0
  end

  it "adds more numbers" do
    calculate("1 + 2 + 3").should == 6
    calculate("1 + 2 + 3 + 4").should == 10
    calculate(Array(1..10).join(" + ")).should == 55
  end
end

describe "subtraction" do
  it "subtracts two numbers" do
    calculate("1 - 2").should == -1
    calculate("3 - 2").should == 1
    calculate("10 - 7").should == 3
    calculate("0 - 10").should == -10
  end

  it "subtracts more numbers" do
    calculate("1 - 2 - 3").should == -4
    calculate("10 - 5 - 5").should == 0
    calculate(Array(1..10).join(" - ")).should == -53
  end
end

describe "multiplcation" do
  it "multiplies two numbers" do
    calculate("1 * 2").should == 2
    calculate("2 * 4").should == 8
    calculate("3 * 3").should == 9
  end

  it "multiplies more numbers" do
    calculate("1 * 2 * 3").should == 6
    calculate("2 * 3 * 4").should == 24
    calculate(Array(1..10).join(" * ")).should == 3628800
  end
end

describe "division" do
  it "divides two numbers" do
    calculate("1 / 2").should == 0
    calculate("2 / 1").should == 2
    calculate("2 / 2").should == 1
    calculate("5 / 2").should == 2
    calculate("5 / 3").should == 1
  end

  it "divides more numbers" do
    calculate("6 / 3 / 2").should == 1
    calculate("12 / 3 / 2").should == 2
    calculate("16 / 2 / 2 / 2").should == 2
    calculate("32 / 2 / 2 / 2 / 3").should == 1
    calculate(Array(1..10).join(" / ")).should == 0
  end
end

describe "parentheses" do
  it "evaluates parentheses" do
    calculate("(1)").should == 1
    calculate("(10)").should == 10
  end

  it "evaluates operations inside parentheses" do
    calculate("(1 + 2)").should == 3
    calculate("(1 - 2)").should == -1
    calculate("(1 * 2)").should == 2
    calculate("(1 / 2)").should == 0
  end

  it "nests parentheses" do
    calculate("((2))").should == 2
    calculate("(1 + (2))").should == 3
    calculate("(1 + (2 + (3)))").should == 6
    calculate("(1 + (2) + 3)").should == 6
  end
end

describe "order of operations" do
  it "respects MD over AS" do
    calculate("1 + 2 * 3").should == 7
    calculate("2 * 3 + 1").should == 7
    calculate("2 / 3 + 1").should == 1
    calculate("2 / 3 - 1").should == -1
    calculate("2 * 3 - 1").should == 5
    calculate("1 - 2 * 3").should == -5
    calculate("1 + 2 * 3 - 4 / 5").should == 7
  end

  it "respects parentheses over MD" do
    calculate("2 * (3 / 4)").should == 0
    calculate("(2 * 3) / 4").should == 1
  end

  it "does crazy things with order of operations" do
    calculate("1 + (2 * 3 - 4 * (5 / (6 - 7))) * 8").should == 209
  end
end

describe "negation" do
  it "negates single integers" do
    calculate("-1").should == -1
    calculate("-10").should == -10
  end

  it "operates on negative numbers" do
    calculate("-1 + 2").should == 1
    calculate("2 + -1").should == 1
    calculate("-1 * 2").should == -2
    calculate("3 * -2").should == -6
    calculate("-6 / 2").should == -3
    calculate("6 / -2").should == -3
  end

  it "respects parentheses with negative numbers" do
    calculate("(-1)").should == -1
    calculate("-(1)").should == -1
    calculate("-(-1)").should == 1
    calculate("- ( -1 * -2 * -3)").should == 6
  end
end
