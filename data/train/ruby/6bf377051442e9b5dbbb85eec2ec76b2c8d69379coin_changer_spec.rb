#coin_changer_spec.rb
require 'rspec'
require_relative 'coin_changer'

describe CoinChanger do
  	it "returns 0,3,2,0,4 when input is 0" do
		input = 99
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,3,2,0,4])
	end
  
	it "returns 0,0,0,0,0 when input is 0" do
		input = 0
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,0,0,0,0])
	end
	
	it "returns 1,1,1,1,1 when input is 141" do
		input = 141
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([1,1,1,1,1])
	end
	
	it "returns 0,0,0,0,1 when input is 1" do
		input = 1
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,0,0,0,1])
	end
	it "returns 0,0,0,1,0 when input is 5" do
		input = 5
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,0,0,1,0])
	end
	it "returns 0,0,1,0,0 when input is 10" do
		input = 10
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,0,1,0,0])
	end
	it "returns 0,1,0,0,0 when input is 25" do
		input = 25
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,1,0,0,0])
	end
	it "returns 1,0,0,0,0 when input is 100" do
		input = 100
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([1,0,0,0,0])
	end



	it "returns 0,0,0,1,1 when input is 6" do
		input = 6
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,0,0,1,1])
	end

	it "returns 0,0,1,1,1 when input is 16" do
		input = 16
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,0,1,1,1])
	end

	it "returns 0,1,1,1,1 when input is 41" do
		input = 41
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([0,1,1,1,1])
	end

	it "returns 5,3,1,1,4 when input is 594" do
		input = 594
		a = CoinChanger.new
		output = a.calculate(input)
		output.should eq([5,3,1,1,4])
	end
end

