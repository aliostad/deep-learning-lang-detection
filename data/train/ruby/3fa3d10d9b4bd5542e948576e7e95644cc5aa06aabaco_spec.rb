require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Abaco do
  it "should shorten with tinyurl" do
    Abaco.calculate_time(10.minutes.ago).should == "10 minutes ago"
    Abaco.calculate_time(1.minute.ago).should == "1 minute ago"
    Abaco.calculate_time(40.seconds.ago).should == "40 seconds ago"
    Abaco.calculate_time(2.hours.ago).should == "2 hours ago"
    Abaco.calculate_time(1.hour.ago).should == "1 hour ago"
    Abaco.calculate_time(5.days.ago).should == "5 days ago"
    Abaco.calculate_time(1.day.ago).should == "yesterday"
    Abaco.calculate_time(7.days.ago).should == "1 week ago"
    Abaco.calculate_time(15.days.ago).should == "2 weeks ago"
  end

end

