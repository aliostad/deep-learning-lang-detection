require 'spec_helper'
require 'warmup04-DB'

describe "Warmup 04: String Calculator" do

  describe "Adding numbers" do
    it 'Adds 3 + 3 => 6' do
      expect(calculate_string('What is 3 + 3?')).to eq(6)
    end

    it 'Adds 3 + -3 => 0' do
      expect(calculate_string('What is 3 + -3?')).to eq(0)
    end

    it 'Adds -3 + 3 => 0' do
      expect(calculate_string('What is -3 + 3?')).to eq(0)
    end

    it 'Adds -3 + -3 => 0' do
      expect(calculate_string('What is -3 + -3?')).to eq(-6)
    end

    it 'Adds 234 + 62 => 296' do
      expect(calculate_string('What is 234 + 62?')).to eq(296)
    end

    it 'Adds 450 + 78 => 528' do
      expect(calculate_string('What is 450 + 78')).to eq(528)
    end
  end

  describe "Bonus problems" do
    it 'Subtracts: 3 - 3, returns 0' do
      expect(calculate_string('What is 3 - 3?')).to eq(0)
    end

    it 'Multiplies: 3 * 3, returns 9' do
      expect(calculate_string('What is 3 * 3?')).to eq(9)
    end

    it 'Divides: 9 / 3 returns 3' do
      expect(calculate_string('What is 9 / 3')).to eq(3)
    end
  end
end
