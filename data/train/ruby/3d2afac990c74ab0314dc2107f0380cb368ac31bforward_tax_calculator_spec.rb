require 'spec_helper'

module Bitsy
  describe ForwardTaxCalculator do

    describe '#calculate' do
      it 'should return an the correct amount that should be taxed from the payment' do
        amount = described_class.calculate(0.8, 1.0, 0.8, 0.5, 0.05)
        expect(amount).to eq 0.4

        amount = described_class.calculate(1.0, 1.0, 2.0, 0.4, 0.3)
        expect(amount).to eq 0.3

        amount = described_class.calculate(2.0, 1.0, 2.0, 0.4, 0.2)
        expect(amount).to eq(0.4 + 0.2 * 1.0)

        amount = described_class.calculate(1.5, 0.5, 2.5, 0.5, 0.05)
        expect(amount).to eq 0.05 * 1.5
      end
    end
  end
end
