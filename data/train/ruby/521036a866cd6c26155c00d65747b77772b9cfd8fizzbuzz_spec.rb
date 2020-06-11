require 'rspec'
require 'fizzbuzz.rb'

describe 'Calulator class' do
	 it 'should return 1 from 1' do
	 	@calculator = Calculator.new
	 	@calculator.calculate(1).should == 1
	 end
	 it 'returns 2 from 2' do
	 	 @calculator = Calculator.new
	 	 @calculator.calculate(2).should == 2
	 end
	  it 'returns fizz from 3' do 
	    @calculator = Calculator.new
	 	@calculator.calculate(3).should == "fizz"
	 end
	 it 'returns 4 from 4' do
	     @calculator = Calculator.new
	 	 @calculator.calculate(4).should == 4
	  end

end
