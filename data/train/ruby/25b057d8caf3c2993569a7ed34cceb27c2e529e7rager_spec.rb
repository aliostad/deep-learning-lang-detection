require 'spec_helper'

describe Vorlauf::Formulas::Rager do
  describe '#calculate' do
    it 'returns 35' do  # 28
      expect(Vorlauf::Formulas::Rager.calculate(1.041, 10, 60, 14.7, 8).round(1)).to eql(35.0)
    end

    it 'returns 5.6' do # 7.4
      expect(Vorlauf::Formulas::Rager.calculate(1.041, 10, 10, 7.75, 8).round(1)).to eql(4.2)
    end

    it 'returns 1.5' do #2
      expect(Vorlauf::Formulas::Rager.calculate(1.041, 10, 10, 4.25, 4).round(1)).to eql(1.1)
    end

    it 'returns 0.9' do # 0.9
      expect(Vorlauf::Formulas::Rager.calculate(1.041, 10, 5, 4.5, 4).round(1)).to eql(1.0)
    end

  end
end
