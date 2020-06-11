require 'benchmark'
require './testable.jar'

time = Benchmark.measure do
  testable = Java::TestableClass1.new
  testable.calculate(10) == 10
  testable = Java::TestableClass1.new
  testable.calculate(100) == 100
  testable = Java::TestableClass1.new
  testable.calculate(10) != 100
  testable = Java::TestableClass2.new
  testable.calculate(10) == 23
  testable = Java::TestableClass2.new
  testable.calculate(100) == 2318
  testable = Java::TestableClass2.new
  testable.calculate(1000) == 233168
  testable = Java::TestableClass2.new
  testable.calculate(10) != 24
  testable = Java::TestableClass3.new
  testable.calculate(10) == 2640
  testable = Java::TestableClass3.new
  testable.calculate(100) == 25164150
  testable = Java::TestableClass3.new
  testable.calculate(10) != 2641
  testable = Java::TestableClass4.new
  testable.calculate(10) == 55
  testable = Java::TestableClass4.new
  testable.calculate(20) == 6765
  testable = Java::TestableClass4.new
  testable.calculate(10) != 56
end
puts time
