<<-PROBLEM

Write a method called 'calculate' that produces this output:

calculate("2 3 +")      # => 5
calculate("12 2 /")     # => 6
calculate("48 4 6 * /") # => 2

PROBLEM

def calculate(expression)
  arr      = expression.split(' ')
  len      = arr.size / 2
  num, ops = arr[0..len].collect(&:to_i), arr[-len..-1].collect(&:to_sym)

  ops.inject(0) do |s, op|
    s == 0 ? (val2, val1 = [num.pop, num.pop]) : (val1, val2 = [num.pop, s])
    val1.send(op, val2)
  end
end

##############
# TEST BENCH #
##############

require 'rspec'

describe '#calculate' do
  context 'with two numbers' do
    it 'adds' do
      expect(calculate('6 3 +')).to eq(9)
    end

    it 'subtracts' do
      expect(calculate('6 3 -')).to eq(3)
    end

    it 'multiplies' do
      expect(calculate('8 2 *')).to eq(16)
    end

    it 'divides' do
      expect(calculate('8 2 /')).to eq(4)
    end
  end

  context 'with more than two numbers' do
    it 'adds and subtracts' do
      expect(calculate('13 3 7 + -')).to eq(3)
    end

    it 'multiplies and divides' do
      expect(calculate('16 2 4 * /')).to eq(2)
    end

    it 'handles all calculation types' do
      expect(calculate('-12 2 3 4 5 + - * /')).to eq(1)
    end
  end

  context 'with initial problem conditions' do
    it 'returns expected output for example 1' do
      expect(calculate('2 3 +')).to eq(5)
    end

    it 'returns expected output for example 2' do
      expect(calculate('12 2 /')).to eq(6)
    end

    it 'returns expected output for example 3' do
      expect(calculate('48 4 6 * /')).to eq(2)
    end
  end
end
