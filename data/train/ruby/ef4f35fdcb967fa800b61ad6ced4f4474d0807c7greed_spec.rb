require 'rspec'
require_relative '../lib/greed'

describe Greed do

  before do
    @greed = Greed.new
  end

  it 'should score 100 for a single 1' do
    @greed.calculate_best_score([1,2,2,3,3]).should == 100
  end

  it 'should score 200 for two 1s' do
    @greed.calculate_best_score([1,1,2,2,3]).should == 200
  end

  it 'should score 1000 for three 1s' do
    @greed.calculate_best_score([1,1,1,2,2]).should == 1000
  end

  it 'should score 1100 for four 1s' do
    @greed.calculate_best_score([1,1,1,1,2]).should == 1100
  end

  it 'should score 200 for three 2s' do
    @greed.calculate_best_score([3,3,2,2,2]).should == 200
  end

  it 'should score 50 for single 5' do
    @greed.calculate_best_score([5,2,3,4,6]).should == 50
  end

  it 'should score 100 for two 5s' do
    @greed.calculate_best_score([5,5,3,4,6]).should == 100
  end

  it 'should score 300 for three 3s' do
    @greed.calculate_best_score([3,3,3,2,2]).should == 300
  end

  it 'should score 400 for three 4s' do
    @greed.calculate_best_score([4,4,4,2,2]).should == 400
  end

  it 'should score 500 for three 5s' do
    @greed.calculate_best_score([5,5,5,2,2]).should == 500
  end

  it 'should score 600 for three 6s' do
    @greed.calculate_best_score([6,6,6,2,2]).should == 600
  end

  it 'should work for the examples' do
    @greed.calculate_best_score([1,1,1,5,1]).should == 1150
    @greed.calculate_best_score([2,3,4,6,2]).should == 0
    @greed.calculate_best_score([3,4,5,3,3]).should == 350
    @greed.calculate_best_score([1,5,1,2,4]).should == 250
    @greed.calculate_best_score([5,5,5,5,5]).should == 600
  end
end