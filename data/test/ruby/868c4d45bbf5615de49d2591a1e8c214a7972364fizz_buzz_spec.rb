require 'rspec'
require './fizz_buzz'

describe FizzBuzz do
	describe '.calculate' do
		it 'is an array' do
			expect(FizzBuzz.new.calculate).to be_an(Array)
		end

		it 'first number is 1' do 
			expect(FizzBuzz.new.calculate[0]).to eql(1)
		end

		it 'third number is fizz' do
			expect(FizzBuzz.new.calculate[2]).to eql('fizz')
		end

		it 'nintey-ninth number is fizz' do
			expect(FizzBuzz.new.calculate[98]).to eql('fizz')
		end

		it 'fiftenth number is fizzbuxx' do
			expect(FizzBuzz.new.calculate[14]).to eql('fizzbuzz')
		end
	end
end