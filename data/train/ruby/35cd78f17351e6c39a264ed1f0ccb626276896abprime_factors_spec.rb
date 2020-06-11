# Run test with: `rspec spec -c`

require 'spec_helper'

describe PrimeCalculator do

	before :each do
		@calculator = PrimeCalculator.new
	end

	describe '#new' do
		it "returns new PrimeCalculator object" do
			expect(@calculator).to be_an_instance_of(PrimeCalculator)
		end
	end

	describe '#calculate' do
		# it "returns invalid for input 1" do
		# 	expect(@calculator.calculate(1)).to eq('invalid')
		# end

		it "calculates the prime factors for 2" do
			expect(@calculator.calculate(2)).to eq([2])
		end

		it "calculates the prime factors for 3" do
			expect(@calculator.calculate(3)).to eq([3])
		end

		it "calculates the prime factors for 4" do
			expect(@calculator.calculate(4)).to eq([2, 2])
		end

		it "calculates the prime factors for 5" do
			expect(@calculator.calculate(5)).to eq([5])
		end

		it "calculates the prime factors for 6" do
			expect(@calculator.calculate(6)).to eq([2, 3])
		end

		it "calculates the prime factors for 7" do
			expect(@calculator.calculate(7)).to eq([7])
		end

		it "calculates the prime factors for 8" do
			expect(@calculator.calculate(8)).to eq([2, 2, 2])
		end

		it "calculates the prime factors for 9" do
			expect(@calculator.calculate(9)).to eq([3, 3])
		end

		it "calculates the prime factors for 10" do
			expect(@calculator.calculate(10)).to eq([2, 5])
		end

		it "calculates the prime factors for 50" do
			expect(@calculator.calculate(50)).to eq([2, 5, 5])
		end

	end

end