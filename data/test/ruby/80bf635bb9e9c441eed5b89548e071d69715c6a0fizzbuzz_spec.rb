# FizzBuzz Spec Test

require 'rspec'
require File.join(File.dirname(__FILE__), 'fizzbuzz.rb')


describe FizzBuzz do
  before (:each) do
    @fizzbuzz = FizzBuzz.new  
  end
    
  it "should return 1 for 1" do
    @fizzbuzz.calculate(1).should == 1
  end

  it "should return 2 for 2" do
    @fizzbuzz.calculate(2).should == 2
  end

  it "should return 'FIZZ' when number is dividable by 3 or if it has a 3 in it" do
    @fizzbuzz.calculate(3).should == 'FIZZ'
    @fizzbuzz.calculate(6).should == 'FIZZ'
    @fizzbuzz.calculate(9).should == 'FIZZ'
    @fizzbuzz.calculate(13).should == 'FIZZ'

  end

  it "should return 'BUZZ' when number is dividable by 5 or if it has a 5 in it" do
    @fizzbuzz.calculate(5).should == 'BUZZ'
    @fizzbuzz.calculate(10).should == 'BUZZ'
    @fizzbuzz.calculate(56).should == 'BUZZ'
  end

  it "should return 'FIZZBUZZ' when number is dividable by 15 or if it has a 3 in it and if it has a 5 in it" do
    @fizzbuzz.calculate(15).should == 'FIZZBUZZ'
    @fizzbuzz.calculate(30).should == 'FIZZBUZZ'
    @fizzbuzz.calculate(53).should == 'FIZZBUZZ'
  end
end