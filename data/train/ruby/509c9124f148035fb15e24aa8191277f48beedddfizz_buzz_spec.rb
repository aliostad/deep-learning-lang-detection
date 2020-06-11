require 'rspec'
require './fizz_buzz'

describe FizzBuzz do 
	describe '.calculate' do
		it 'is an array' do
			expect(FizzBuzz.new.calculate).to be_an(Array)
		end
		it 'first number is 1' do
			expect(FizzBuzz.new.calculate.first).to eql(1)
		end
		it 'third number is fizz' do
			expect(FizzBuzz.new.calculate[2]).to eql("Fizz")
		end
		it 'fifth number is fizz' do
			expect(FizzBuzz.new.calculate[4]).to eql("Buzz")
		end
		it '99th number is fizz' do
			expect(FizzBuzz.new.calculate[98]).to eql("Fizz")
		end
		it '15th number is fizzbuzz' do
			expect(FizzBuzz.new.calculate[14]).to eql("FizzBuzz")
		end
	end
end
