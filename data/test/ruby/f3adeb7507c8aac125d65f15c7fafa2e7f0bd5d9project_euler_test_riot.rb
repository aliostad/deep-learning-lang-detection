require 'riot'
require './testable.jar'

context "TestableClass1" do
  setup do
    Java::TestableClass1.new
  end

  asserts("values for 10")  { topic.calculate(10) }.equals(10)
  asserts("values for 100") { topic.calculate(100) }.equals(100)
  denies("values for 10")   { topic.calculate(10) }.equals(100)
end

context "TestableClass2" do
  setup do
    Java::TestableClass2.new
  end

  asserts("values for 10") { topic.calculate(10) }.equals(23)
  asserts("values for 100") { topic.calculate(100) }.equals(2318)
  asserts("values for 1000") { topic.calculate(1000) }.equals(233168)
  denies("values for 10")   { topic.calculate(10) }.equals(24)
end

context "TestableClass3" do
  setup do
    Java::TestableClass3.new
  end

  asserts("values for 10") { topic.calculate(10) }.equals(2640)
  asserts("values for 100") { topic.calculate(100) }.equals(25164150)
  denies("values for 10")   { topic.calculate(10) }.equals(2641)
end

context "TestableClass4" do
  setup do
    Java::TestableClass4.new
  end

  asserts("values for 10") { topic.calculate(10) }.equals(55)
  asserts("values for 20") { topic.calculate(20) }.equals(6765)
  denies("values for 10")   { topic.calculate(10) }.equals(56)
end