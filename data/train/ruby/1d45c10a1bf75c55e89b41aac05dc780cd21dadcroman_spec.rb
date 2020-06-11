require 'rspec'
require 'roman.rb'

describe 'roman numerals' do
		before do
				@romanCalculator = RomanCalculator.new
		end
		it 'returns I for 1' do
				@romanCalculator.calculate(1).should == "I"
		end
		it 'returns II for 2' do
				@romanCalculator.calculate(2).should == "II"
		end
		it 'returns III for 3' do
				@romanCalculator.calculate(3).should == "III"
		end
		it 'returns IV for 4' do
				@romanCalculator.calculate(4).should == "IV"
		end
		it 'returns V for 5' do
				@romanCalculator.calculate(5).should == "V"
		end
		it 'returns VI for 6' do
				@romanCalculator.calculate(6).should == "VI"
		end
		it 'returns VII for 7' do
				@romanCalculator.calculate(7).should == "VII"
		end
		it 'returns VIII for 8' do
				@romanCalculator.calculate(8).should == "VIII"
		end
		it 'returns IX for 9' do
				@romanCalculator.calculate(9).should == "IX"
		end
		it 'returns X for 10' do
				@romanCalculator.calculate(10).should == "X"
		end
		it 'returns L for 50' do
				@romanCalculator.calculate(50).should == "L"
		end
		it 'returns D for 500' do
				@romanCalculator.calculate(500).should == "D"
		end
		it 'returns M for 1000' do
				@romanCalculator.calculate(1000).should == "M"
		end
end
