require 'spec_helper'

describe 'Exercising the scoring system' do
  subject(:calculator) { Calculator.new(test_case) }

  describe '#calculate' do
    context 'when the test_case is 5' do
      let(:test_case) { 5 }

      specify { expect(calculator.calculate).to eq 0 }
    end
  end

  describe '#calculate' do
    context 'when the test_case is 2' do
      let(:test_case) { 2 }

      specify { expect(calculator.calculate).to eq 0.25 }
    end
  end

  describe '#calculate' do
    context 'when the test_case is 4' do
      let(:test_case) { 4 }

      specify { expect(calculator.calculate).to eq 0.5 }
    end
  end

  describe '#calculate' do
    context 'when the test_case is 12' do
      let(:test_case) { 12 }

      specify { expect(calculator.calculate).to eq 1 }
    end
  end

  describe '#calculate' do
    context 'when the test_case is 13' do
      let(:test_case) { 13 }

      specify { expect(calculator.calculate).to eq 0.5 }
    end
  end

  describe '#calculate' do
    context 'when the test_case is 14' do
      let(:test_case) { 14 }

      specify { expect(calculator.calculate).to eq 0.75 }
    end
  end
end
