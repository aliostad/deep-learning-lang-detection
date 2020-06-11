require 'spec_helper'

module Bodhi
  describe Metric do
    it "should calculate averages" do
      m = Metric.average :dogs, :num_puppies

      m.current.should == 6
    end

    it "should calculate sums" do
      m = Metric.sum :dogs, :num_puppies

      m.current.should == 18
    end

    it "should calculate minimums" do
      m = Metric.minimum :dogs, :num_puppies

      m.current.should == 2
    end

    it "should calculate maximums" do
      m = Metric.maximum :dogs, :num_puppies

      m.current.should == 10
    end
  end
end