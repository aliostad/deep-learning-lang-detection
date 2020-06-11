require 'debugger'
require_relative 'total_robot_paths'

describe "total robot paths" do
  describe :calculate_total_paths do
    it "1x1" do 
      calculate_total_paths(1,1).should eq 1
    end

    it "2x2" do
      calculate_total_paths(2,2).should eq 2      
    end


    it "3x3" do
      calculate_total_paths(3,3).should eq 6    
    end
    
    it "4x4" do
      calculate_total_paths(4,4).should eq 20 
    end
    
    it "5x5" do
      calculate_total_paths(5,5).should eq 70 
    end
    
    it "6x6" do
      calculate_total_paths(6,6).should eq 252 
    end
    
    it "3x5" do
      calculate_total_paths(3,5).should eq 15 
    end

    it "5x3" do
      calculate_total_paths(5,3).should eq 15 
    end
  end
end
