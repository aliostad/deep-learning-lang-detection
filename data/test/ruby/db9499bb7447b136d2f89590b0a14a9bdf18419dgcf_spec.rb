require_relative 'gcf.rb'
include CalculateGreatestCommonFactor

describe 'Calculate Factors' do
  it 'should return an arary' do
    expect(calculate_factors(3).class).to be(Array)
end

  it 'should find all factors of a number' do
    expect(calculate_factors(6)).to eq([1,2,3,6])
  end
end


describe 'find_greatest_factor' do
  it 'should return an integer' do
    expect(find_greatest_factor(3,4).class).to be(Fixnum)
  end

  it 'should find the greatest common factor' do
    expect(find_greatest_factor(4,8)).to eq(4)
  end
end
