require 'rspec'
require 'fizzbuzz.rb'

describe 'fizzbuzz calculator' do
	before do
		@calculator = Calculator.new
	end

	# NOTE: 
	# this first test is solved for you (we did this one the day before)
	# use this example to think about how to solve the next test...
	# ...see "Instructions" below.

	it 'returns 1 from 1' do
		@calculator.calculate(1).should == 1
	end


	it 'returns 2 from 2' do
	   @calculator.calculate(2).should == 2
    end

	it 'returns fizz from 3' do 
	   @calculator.calculate(3).should == "fizz"
    end

	it 'returns 4 from 4' do
	   @calculator.calculate(4).should == 4
	end
	   
	it 'returns buzz from 5' do
	   @calculator.calculate(5).should == 5
	end

	it 'returns fizz from 6' do
	   @calculator.calculate(6).should == 6
	end
	   
	it 'returns 7 from 7' do
	  @calculator.calculate(7).should == 7
    end

	#it 'returns fizzbuzz from 15'
     #  @calculator.calculate(15).should == 15

end