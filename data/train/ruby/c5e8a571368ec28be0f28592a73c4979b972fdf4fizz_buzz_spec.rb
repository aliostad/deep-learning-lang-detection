require 'rspec'
require './fizz_buzz'

describe FizzBuzz do 
	describe '.calculate' do
		# test that the output of calculate is an array
		it 'is an array' do
			expect(FizzBuzz.new.calculate).to be_an(Array)
		end

		# test that the first entry of the output array is 1
		it 'first number is 1' do
			expect(FizzBuzz.new.calculate[0]).to eql(1)
		end

		it 'third number is fizz' do 
			expect(FizzBuzz.new.calculate[2]).to eql("fizz")
		end

		it 'fifth number is buzz' do
			expect(FizzBuzz.new.calculate[4]).to eql("buzz")
		end

		it '99th number is fizz' do
			expect(FizzBuzz.new.calculate[98]).to eql("fizz")
		end

		it '15th number is fizzbuzz' do
			expect(FizzBuzz.new.calculate[14]).to eql('fizzbuzz')
		end

	end
end