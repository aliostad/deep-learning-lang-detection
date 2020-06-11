require 'rspec'
require 'fizzbuzz.rb'

describe 'Calculate class' do
	it 'should return 1 of 1' do
		@calculate = Calculator.new
		@calculate.calculate(1).should == 1
	end


    it 'returns 2 from 2' do
    	@calculate = Calculator.new
		@calculate.calculate(2).should == 2
    end

    it 'returns string fizz when it receives 3' do
    	@calculate = Calculator.new
		@calculate.calculate(3).should == "fizz"
	end

    it 'returns 4 from 4' do
    	@calculate = Calculator.new
		@calculate.calculate(4).should == 4
		end

    it 'returns buzz from 5' do
    	@calculate = Calculator.new
		@calculate.calculate(5).should == "buzz"
		end
end