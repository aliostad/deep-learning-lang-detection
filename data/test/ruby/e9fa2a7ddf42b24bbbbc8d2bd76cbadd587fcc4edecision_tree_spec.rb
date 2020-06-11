require File.dirname(__FILE__) + '/spec_helper'
require 'aiproject3/dataset'
require 'aiproject3/decision_tree'

describe DecisionTree do

  before(:each) do
     @dataset = Dataset.new( :data_filename => "./spec/testcases/testcase.data", :testing => true )
     @test_decision_tree = DecisionTree.new(:dataset => @dataset)
  end

  it "should calculate current entropy correctly" do
    @test_decision_tree.calculate_entropy.should == 1
  end
  
  it "should calculate the entropy remainder correctly" do
    @test_decision_tree.calculate_entropy_remainder(:patrons).round(3).should == 0.459
  end

  it "should calculate the information gain correctly" do
    @test_decision_tree.calculate_information_gain(:patrons).round(3).should == 0.541
  end

  it "should choose the best attribute to split on" do
    @test_decision_tree.best_attribute.should == :patrons
  end

end
