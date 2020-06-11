require './testable.jar'

describe Java::TestableClass1, "calculation" do
  before(:each) do
    @problem = Java::TestableClass1.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should eq 10
  end

  it "returns correct value for 100" do
    @problem.calculate(100).should eq 100
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should_not eq 100
  end
end

describe Java::TestableClass2, "calculation" do
  before(:each) do
    @problem = Java::TestableClass2.new
  end

  it "returns correct values for 10" do
    @problem.calculate(10).should eq 23
  end

  it "returns correct values for 100" do
    @problem.calculate(100).should eq 2318
  end

  it "returns correct values for 1000" do
    @problem.calculate(1000).should eq 233168
  end

  it "returns correct values for 10" do
    @problem.calculate(10).should_not eq 24
  end
end

describe Java::TestableClass3, "calculation" do
  before(:each) do
    @problem = Java::TestableClass3.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should eq 2640
  end

  it "returns correct value for 100" do
    @problem.calculate(100).should eq 25164150
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should_not eq 2641
  end
end

describe Java::TestableClass4, "calculation" do
  before(:each) do
    @problem = Java::TestableClass4.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should eq 55
  end

  it "returns correct value for 100" do
    @problem.calculate(20).should eq 6765
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should_not eq 56
  end
end