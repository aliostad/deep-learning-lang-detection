require 'benchmark'
require './testable.rb'

time = Benchmark.measure do
  testable = TestableClass1.new
  testable.calculate(10) == 10
  testable = TestableClass1.new
  testable.calculate(100) == 100
  testable = TestableClass1.new
  testable.calculate(10) != 100
  testable = TestableClass2.new
  testable.calculate(10) == 23
  testable = TestableClass2.new
  testable.calculate(100) == 2318
  testable = TestableClass2.new
  testable.calculate(1000) == 233168
  testable = TestableClass2.new
  testable.calculate(10) != 24
  testable = TestableClass3.new
  testable.calculate(10) == 2640
  testable = TestableClass3.new
  testable.calculate(100) == 25164150
  testable = TestableClass3.new
  testable.calculate(10) != 2641
  testable = TestableClass4.new
  testable.calculate(10) == 55
  testable = TestableClass4.new
  testable.calculate(20) == 6765
  testable = TestableClass4.new
  testable.calculate(10) != 56
end
puts time
