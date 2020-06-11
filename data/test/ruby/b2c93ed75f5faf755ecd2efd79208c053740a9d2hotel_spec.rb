require 'spec_helper'
require 'hotel'

describe "hotel" do
  it "should calculate period within year" do
    data = [{"one"=>{"start"=>"05-01", "end"=>"05-13", "rate"=>"$137"}}]
    date_range = Date.parse("2011-01-01")..Date.parse("2011-05-03")
    calculate_period(data, date_range).should == 137*3.0
  end
  it "should calculate period across years" do
    data = [{"one"=>{"start"=>"05-14", "end"=>"04-30", "rate"=>"$137"}}]
    date_range = Date.parse("2011-01-01")..Date.parse("2011-05-03")
    calculate_period(data, date_range).should == 137*120.0
  end
  it "should calculate rates" do
    calculate_total('sample_vacation_rentals.json', 'sample_input.txt').should ==
      File.read('sample_output.txt')
  end
end
