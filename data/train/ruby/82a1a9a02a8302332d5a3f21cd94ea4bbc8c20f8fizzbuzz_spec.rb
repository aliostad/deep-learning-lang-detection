require_relative 'fizzbuzz'

describe FizzBuzz do

  describe '.calculate' do
    it 'returns the number itself if no special rules apply' do
      expect(FizzBuzz.calculate 1).to eq 1
      expect(FizzBuzz.calculate 98).to eq 98
    end

    it 'returns Fizz if the number is divisible by 3' do
      expect(FizzBuzz.calculate 3).to eq 'Fizz'
      expect(FizzBuzz.calculate 6).to eq 'Fizz'
    end

    it 'returns Buzz if the number is divisible by 5' do
      expect(FizzBuzz.calculate 5).to eq 'Buzz'
      expect(FizzBuzz.calculate 10).to eq 'Buzz'
    end

    it 'returns Fizzbuzz if the number is divisible by 3 and 5' do
      expect(FizzBuzz.calculate 15).to eq 'Fizzbuzz'
      expect(FizzBuzz.calculate 30).to eq 'Fizzbuzz'
    end

    context 'invalid input' do
      it 'fails gracefully when handed a string' do
        expect {FizzBuzz.calculate 'oh noez'}.to raise_error ArgumentError
      end

      it 'fails gracefully when handed something' do
        expect {FizzBuzz.calculate []}.to raise_error ArgumentError
      end
    end
  end

end