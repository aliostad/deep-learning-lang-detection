require 'rspec'
require './calculator'

describe '#calculate' do
  context 'with two numbers' do
    it 'adds' do
      expect( calculate('6 3 +') ).to eq(9)
    end

    it 'subtracts' do
      expect( calculate('6 3 -') ).to eq(3)
    end

    it 'multiplies' do
      expect( calculate('8 2 *') ).to eq(16)
    end

    it 'divides' do
      expect( calculate('8 2 /') ).to eq(4)
    end
  end

  context 'with more than two numbers' do
    it 'adds and subtracts' do
      expect( calculate('13 3 7 + -') ).to eq(3)
    end

    it 'multiplies and divides' do
      expect( calculate('16 2 4 * /') ).to eq(2)
    end

    it 'handles all calculation types' do
      expect( calculate('-12 2 3 4 5 + - * /') ).to eq(1)
    end
  end

  context 'with initial problem conditions' do
    it 'returns expected output for example 1' do
      expect( calculate('2 3 +') ).to eq(5)
    end

    it 'returns expected output for example 2' do
      expect( calculate('12 2 /') ).to eq(6)
    end

    it 'returns expected output for example 3' do
      expect( calculate('48 4 6 * /') ).to eq(2)
    end
  end
end
