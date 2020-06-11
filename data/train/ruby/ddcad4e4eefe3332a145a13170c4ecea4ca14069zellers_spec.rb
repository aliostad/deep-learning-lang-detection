require_relative '../lib/zellers'

RSpec.describe ZellersCongruence do
  context ".calculate" do
    it "should give the correct date 09-25-87" do
      day = ZellersCongruence.calculate("September", 25, 1987)
      day.should == "Friday"
    end

    it "should give the correct date 11-10-90" do
      day = ZellersCongruence.calculate("November", 10, 1990)
      day.should == "Saturday"
    end

    it "should give the correct date 05-18-64" do
      day = ZellersCongruence.calculate("May", 18, 1964)
      day.should == "Monday"
    end

    it "should give the correct date 03-20-75" do
      day = ZellersCongruence.calculate("March", 20, 1975)
      day.should == "Thursday"
    end

    it "should give the correct date 12-12-66" do
      day = ZellersCongruence.calculate("December", 12, 1966)
      day.should == "Monday"
    end

    it "should give the correct date 04-07-06" do
      day = ZellersCongruence.calculate("April", 07, 2006)
      day.should == "Friday"
    end

    it "should give the correct date 01-19-14" do
      day = ZellersCongruence.calculate("January", 19, 2014)
      day.should == "Sunday"
    end

    it "should give the correct date 02-15-12" do
      day = ZellersCongruence.calculate("February", 15, 2012)
      day.should == "Wednesday"
    end

    it "should give the correct date 06-16-15" do
      day = ZellersCongruence.calculate("June", 16, 2015)
      day.should == "Tuesday"
    end

    it "should give the correct date 07-01-11" do
      day = ZellersCongruence.calculate("July", 01, 2011)
      day.should == "Friday"
    end

  end
end
