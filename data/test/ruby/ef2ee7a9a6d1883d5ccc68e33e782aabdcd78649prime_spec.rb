require 'rspec'
require 'prime.rb'

describe 'prime number calculator' do
		before do
				@primeCalculator = PrimeCalculator.new
		end
		it 'returns an empty array for 1' do
				@primeCalculator.calculate(1).should == []
		end
		it 'returns [ 2 ] for 2' do
				@primeCalculator.calculate(2).should == [2]
		end
		it 'returns [ 3 ] for 3' do
				@primeCalculator.calculate(3).should == [3]
		end
		it 'returns [2,2] for 4' do
				@primeCalculator.calculate(4).should == [2,2]
		end
		it 'returns 5 for 5' do
				@primeCalculator.calculate(5).should == [5]
		end
		it 'returns [2,3] for 6' do
				@primeCalculator.calculate(6).should == [2,3]
		end
		it 'returns [ 7 ] for 7' do
				@primeCalculator.calculate(7).should == [7]
		end
		it 'returns [2,2,2] for 8' do
				@primeCalculator.calculate(8).should == [2,2,2]
		end
		it 'returns [3,3] for 9' do
				@primeCalculator.calculate(9).should == [3,3]
		end
end
