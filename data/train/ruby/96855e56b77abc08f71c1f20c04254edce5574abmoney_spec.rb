require 'spec_helper'

describe "money" do
	let(:paise) {Money.new(0,40) }
	let(:rupees) {Money.new(5,0)}
	let(:combination1) {Money.new(5,500)}
	let(:combination2) {Money.new(7,50)}

	it "calculates value with only paise" do
		expect(paise.calculate_value).to eq(0.40)
	end

	it "calculates value with only rupees" do
		expect(rupees.calculate_value).to eq(5.0)
	end

	it "calculates value with combination of rupee" do
		expect(combination1.calculate_value).to eq(10)
	end

	it "adds money" do
		expect(combination1.calculate_value + combination2.calculate_value).to eq(17.50)
	end
end

