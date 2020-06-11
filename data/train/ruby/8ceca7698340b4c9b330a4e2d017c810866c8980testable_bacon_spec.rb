require './testable.rb'
require 'bacon'

describe TestableClass1, "calculation" do
  before do
    @problem = TestableClass1.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should.equal 10
  end

  it "returns correct value for 100" do
    @problem.calculate(100).should.equal 100
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should.not.equal 100
  end
end

describe TestableClass2, "calculation" do
  before do
    @problem = TestableClass2.new(3,5)
  end

  it "returns correct values for 10" do
    @problem.calculate(10).should.equal 23
  end

  it "returns correct values for 100" do
    @problem.calculate(100).should.equal 2318
  end

  it "returns correct values for 1000" do
    @problem.calculate(1000).should.equal 233168
  end

  it "returns correct values for 10" do
    @problem.calculate(10).should.not.equal 24
  end
end

describe TestableClass3, "calculation" do
  before do
    @problem = TestableClass3.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should.equal 2640
  end

  it "returns correct value for 100" do
    @problem.calculate(100).should.equal 25164150
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should.not.equal 2641
  end
end

describe TestableClass4, "calculation" do
  before do
    @problem = TestableClass4.new
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should.equal 55
  end

  it "returns correct value for 100" do
    @problem.calculate(20).should.equal 6765
  end

  it "returns correct value for 10" do
    @problem.calculate(10).should.not.equal 56
  end
end