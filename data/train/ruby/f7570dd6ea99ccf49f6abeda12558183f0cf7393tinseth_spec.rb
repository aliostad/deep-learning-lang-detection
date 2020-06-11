require 'spec_helper'

module Vorlauf
  module Formulas
    describe 'Tinseth' do
      describe '#calculate' do
        it 'returns 29.4' do
          expect(Vorlauf::Formulas::Tinseth.calculate(1.041, 10, 60, 14.7, 8).round(1)).to eql(29.4)
        end

        it 'returns 5.6' do
          expect(Vorlauf::Formulas::Tinseth.calculate(1.041, 10, 10, 7.75, 8).round(1)).to eql(5.6)
        end

        it 'returns 1.5' do
          expect(Vorlauf::Formulas::Tinseth.calculate(1.041, 10, 10, 4.25, 4).round(1)).to eql(1.5)
        end

        it 'returns 0.9' do
          expect(Vorlauf::Formulas::Tinseth.calculate(1.041, 10, 5, 4.5, 4).round(1)).to eql(0.9)
        end
      end
    end
  end
end
