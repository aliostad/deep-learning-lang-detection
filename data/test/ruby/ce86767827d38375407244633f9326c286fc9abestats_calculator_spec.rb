require 'rspec'
require_relative '../lib/stats_calculator'

describe StatsCalculator do

  context 'with 3 values' do
    let(:values) { [5,5,1]}

    it 'should calculate median' do
      StatsCalculator.calculate_median(values).should == 5
    end

    it 'should calculate mean' do
      StatsCalculator.calculate_mean(values).should == 3.6666666666666665
    end
  end

  context 'with 4 values' do
    let(:values) { [5,1,5,1]}

    it 'should calculate median' do
      StatsCalculator.calculate_median(values).should == 3
    end

    it 'should calculate mean' do
      StatsCalculator.calculate_mean(values).should == 3
    end
  end

  context 'with 5 unique values' do
    let(:values) { [9,4,7,5,3]}

    it 'should calculate median' do
      StatsCalculator.calculate_median(values).should == 5
    end

    it 'should calculate mean' do
      StatsCalculator.calculate_mean(values).should == 5.6
    end
  end

  context 'with 6 unique values' do
    let(:values) { [26,3,52,7,31]}

    it 'should calculate median' do
      StatsCalculator.calculate_median(values).should == 26
    end

    it 'should calculate mean' do
      StatsCalculator.calculate_mean(values).should == 23.8
    end
  end

  context 'with no values' do
    let(:values){[]}
    it 'should calculate a median of zero' do
      StatsCalculator.calculate_median(values).should == 0
    end
    it 'should calculate a mean of zero' do
      StatsCalculator.calculate_mean(values).should == 0
    end
  end

end
