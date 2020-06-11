# rspec tutorial: https://www.youtube.com/watch?v=cGB7TyqzX3s
require 'rspec'
require_relative '../lib/playnum'

describe Playnum do
  
  before(:each) do
    @calculate = Playnum.new
    puts "Each of them!"
  end

  before(:all) do
    puts "Test starts"
  end
  
  after(:all) do
    puts "Done!"
  end

  describe '#calculate_cube' do
    it 'returns a cube of a number' do
      expect(@calculate.calculate_cube(3)).to eq(27)
      expect(@calculate.calculate_cube(2)).to eq(8)
    end
  end
  describe '#calculate_square' do
    it 'returns a square of a number' do
      expect(@calculate.calculate_square(3)).to eq(9)
      expect(@calculate.calculate_square(2)).to eq(4)
    end
  end
end
