require_relative '../SuperMarket.rb'
require 'rspec'

describe SuperMarket do

  before :each do
    @cart = SuperMarket.new
  end

  it 'will return 1 dollar for bread' do
    @cart.calculateCost('bread').should == 1
  end

  it 'will return 50 cents for noodles' do
    @cart.calculateCost('noodles').should == 0.5
  end

  it 'will return 2 dollars for soupcan' do
    @cart.calculateCost('soupcan').should == 2
  end

  it 'will total several items correctly' do
    @cart.calculateCost('bread')
    @cart.calculateCost('noodles')
    @cart.calculateCost('soupcan')
    @cart.getTotal().should == 3.50
  end

  it 'will return 2 dollars for two breads' do
    @cart.calculateCost('bread',2).should == 2
  end

  it 'will return 2 dollars for apples' do
    @cart.calculateCost('apples').should == 2
  end

  it 'will return 3 dollars for 1.5 apples' do
    @cart.calculateCost('apples',1.5).should == 3
    @cart.getTotal()
  end

  it 'will return 4 dollars for 5 breads' do
    @cart.calculateCost('bread',5).should == 4
    @cart.getTotal()
  end

  it 'will return 1 dollar for 3 noodles' do
    @cart.calculateCost('noodles',3).should == 1
    @cart.getTotal()
  end

end