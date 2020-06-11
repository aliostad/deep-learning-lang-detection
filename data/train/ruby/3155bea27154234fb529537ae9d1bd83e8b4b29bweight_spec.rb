require 'spec_helper'

describe Weight do
  it "should calculate number of plates on one side for 140" do
    num_plates = Weight.calculate_plates(140/2)
    num_plates.should == {
      :num45 => 1,
      :num35 => 0,
      :num25 => 1,
      :num10 => 0,
      :num5 => 0
    }
  end

  it "should calculate number of plates on one side for 280" do
    num_plates = Weight.calculate_plates(280/2)
    num_plates.should == {
      :num45 => 3,
      :num35 => 0,
      :num25 => 0,
      :num10 => 0,
      :num5 => 1
    }
  end

  it "should calculate number of plates on one side for 420" do
    num_plates = Weight.calculate_plates(420/2)
    num_plates.should == {
      :num45 => 4,
      :num35 => 0,
      :num25 => 1,
      :num10 => 0,
      :num5 => 1
    }
  end

  it "should calculate number of plates on one side for 570" do
    num_plates = Weight.calculate_plates(570/2)
    num_plates.should == {
      :num45 => 6,
      :num35 => 0,
      :num25 => 0,
      :num10 => 1,
      :num5 => 1
    }
  end

end
