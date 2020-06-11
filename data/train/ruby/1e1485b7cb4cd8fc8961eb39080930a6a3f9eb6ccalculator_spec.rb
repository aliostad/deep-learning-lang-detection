require 'spec_helper'

module Invoicerb
  describe Calculator do

    subject { Calculator.new }
    let(:quantity) { Value.new('2') }
    let(:price) { Value.new('GBP100') }
    let(:discount) { Value.new('GBP5') }

    context 'Calculator#sum' do

      it "should sum an array of value objects" do
        val1 = Value.new('GBP5')
        val2 = Value.new('GBP10')
        val3 = Value.new('GBP15')
        subject.sum([val1, val2, val3]).to_i.should == 30
      end

      it "should sum an array of value objects even if one is nil" do
        val1 = Value.new('GBP5')
        val2 = nil
        val3 = Value.new('GBP15')
        subject.sum([val1, val2, val3]).to_i.should == 20
      end

      it "should sum an array of numbers even" do
        val1 = 5
        val2 = 10
        val3 = 15
        subject.sum([val1, val2, val3]).to_i.should == 30
      end

    end

    context 'Calculator#calculate' do

      it "should calculate call the calculate_discount method" do
        subject.should_receive(:calculate_discount).with(quantity, price, discount).and_return(5)
        subject.calculate(quantity, price, discount).should == 195
      end

      it "should calculate call the calculate_with_amounts method" do
        subject.should_receive(:calculate_with_amounts).with(2, 100, 5)
        subject.calculate(quantity, price, discount)
      end

    end

    context 'Calculator#discount' do

      it "should calculate the discount" do
        subject.calculate_discount(quantity, price, discount).should == 5.to_f
      end

      it "should not calculate the discount" do
        subject.calculate_discount(quantity, price, nil).should == 0
      end

      it "should calculate the discount as a % if it has a % suffix" do
        discount = Value.new('10%')
        subject.calculate_discount(quantity, price, discount).should == 20
      end

      it "should return the discount if suffix is not a  %" do
        discount = Value.new('40x')
        subject.calculate_discount(quantity, price, discount).should == 40
      end

    end

  end
end
