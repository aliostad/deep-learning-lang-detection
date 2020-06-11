require 'spec_helper'

describe CostCalculatorHelper do
  context '.calculate' do
    it do
    	value = CostCalculatorHelper.calculate(gas_price: '2.5',
                                            vehicle_autonomy: '10',
                                            distance: '25')

    	expect(value).to eq(6.25)
    end

    it 'invalid params' do
      value = CostCalculatorHelper.calculate(gas_price: 'a',
                                             vehicle_autonomy: 'b',
                                             distance: '')

      expect(value).to be(nil)
    end
  end
end
