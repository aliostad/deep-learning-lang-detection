require './testable.rb'
require "minitest/autorun"

describe TestableClass1, "calculation" do
  before(:each) do
    @problem = TestableClass1.new
  end

  it "returns correct values for 10" do
    @problem.calculate(10).must_equal 10
  end

  it "returns correct values for 100" do
    @problem.calculate(100).must_equal 100
  end

  it "returns correct values for 10" do
    @problem.calculate(10).wont_equal 100
  end
end

describe TestableClass2, "calculation" do
  before(:each) do
    @problem = TestableClass2.new(3,5)
  end

  it "returns correct values for 10" do
    @problem.calculate(10).must_equal 23
  end

  it "returns correct values for 100" do
    @problem.calculate(100).must_equal 2318
  end

  it "returns correct values for 1000" do
    @problem.calculate(1000).must_equal 233168
  end

  it "returns correct values for 10" do
    @problem.calculate(10).wont_equal 24
  end
end

describe TestableClass3, "calculation" do
  before(:each) do
    @problem = TestableClass3.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).must_equal 2640
  end

  it "returns correct value for 100" do
    @problem.calculate(100).must_equal 25164150
  end

  it "returns correct value for 10" do
    @problem.calculate(10).wont_equal 2641
  end
end

describe TestableClass4, "calculation" do
  before(:each) do
    @problem = TestableClass4.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).must_equal 55
  end

  it "returns correct value for 20" do
    @problem.calculate(20).must_equal 6765
  end

  it "returns correct value for 10" do
    @problem.calculate(10).wont_equal 56
  end
end
