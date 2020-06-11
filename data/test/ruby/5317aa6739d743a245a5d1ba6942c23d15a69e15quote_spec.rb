require 'spec_helper'

describe 'description' do
  
  #it "Returns a price of zero when no Coordinates" do
      
  #   quote = Quote.new
  #  expect(quote.calculate_price).to eq(0)
  
  #end

  it "Accepts 2 Coordinates" do

    quote = Quote.new([1,1],[2,3])

    expect(quote.from).to eq([1,1])
    expect(quote.to).to eq([2,3])
  end

  it "Calculates the price" do
    
    quote = Quote.new([1,3],[2,6])

    expect(quote.calculate_distance).to eq(3)
  end

  it "If it is a Motorbike, the prize is higher"

    quote = Quote.new([1,3],[2,6], Vehicle[:motorbike])

    expect(quote.calculate_price).to eq(3.59)

end


quote.calculate_price(calculate_distance)