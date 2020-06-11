require './app/services/products/calculate_tax'

RSpec.describe Products::CalculateTax, '#call' do
  context 'with Floats' do
    it 'should calculate the product price with tax' do
      expect(Products::CalculateTax.call(price: 100.0, tax: 21.0)).to eq 121.0
    end
  end
end

RSpec.describe Products::CalculateTax, '#call' do
  context 'with Integers' do
    it 'should coerse the Interges into Floats' do
      expect(Products::CalculateTax.call(price: 100, tax: 21)).to eq 121.0
    end
  end
end

RSpec.describe Products::CalculateTax, '#call' do
  context 'with Strings' do
    it 'should raise an error due to Virtus Strict Mode' do
      expect do
        Products::CalculateTax.call(price: 'a', tax: 'b')
      end.to raise_error(Virtus::CoercionError)
    end
  end
end
