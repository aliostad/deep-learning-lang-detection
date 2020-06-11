require 'spec_helper'

describe Residual do
  describe 'calculate' do
    before do
      @deal = FactoryGirl.build(:deal, term: 36, term_kwh: 300000, mils: 0.003, start_date: "1980-03-11")
      @residual = FactoryGirl.build(:residual, start_month: 12, end_month: 9999)
    end
    
    it 'should return an array of payments' do
      result = @residual.calculate(@deal)
      result.should be_an_instance_of(Array)
      result[0].should be_an_instance_of(Payment)
    end
    
    it 'should return an array with a payment for every month between its start_month and end_month' do
      @residual.calculate(@deal).count.should == 24
    end
    
    it 'should calculate payment in the amount of term_kwh * mils / term' do
      @residual.calculate(@deal)[0].amount.should == 25
    end
    
    it 'should calculate payment months between start_date + start_month and start_date + end_month' do
      @residual.end_month = 24
      @residual.calculate(@deal).count.should == 12
      @residual.calculate(@deal)[0].date.should == DateTime.new(1981, 3, 11)
      @residual.calculate(@deal)[11].date.should == DateTime.new(1982, 2, 11)      
    end
  end
end
