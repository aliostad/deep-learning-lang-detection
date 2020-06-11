require 'rspec'
require File.expand_path('../../calculator.rb', __FILE__)
include Groupon

describe 'calculator test' do

  it 'should calculate result' do
    calculator = Calculator.new
    expression = "2 + ( ( 4 + 6) * ( 9- 2) - 5 - 1) + 1"
    result = calculator.calculate_expression expression
    expect(result).to eq(67)
  end

  it 'should calculate sqrt result' do
    calculator = Calculator.new
    expression = "2 + ( ( 4 + 6 ) * sqrt(5) + 3) / 2  + 1"
    result = calculator.calculate_expression expression
    expect(result).to be_between(15, 16)
  end

end