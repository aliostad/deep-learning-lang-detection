def calculate_intersection(a_from, a_to, b_from, b_to)
  common = [a_to - b_from, b_to - a_from, a_to - a_from, b_to - b_from].min
  common >= 0 ? common : 0
end

def solution(blx1, bly1, trx1, try1, blx2, bly2, trx2, try2)
  width = calculate_intersection(blx1, trx1, blx2, trx2)
  height = calculate_intersection(bly1, try1, bly2, try2)
  area = width * height
  area > 2_147_483_647 ? -1 : area
end

require 'rspec'

describe "#calculate_intersection returns common part" do
  it "when no common part" do
    calculate_intersection(0, 1, 2, 3).should == 0
    calculate_intersection(2, 3, 0, 1).should == 0
  end

  it "when touching" do
    calculate_intersection(0, 1, 1, 2).should == 0
  end

  it "when first is on the left" do
    calculate_intersection(0, 4, 1, 5).should == 3
  end

  it "when first is on the right" do
    calculate_intersection(1, 5, 0, 4).should == 3
  end

  it "when first is smaller than second" do
    calculate_intersection(1, 2, 0, 4).should == 1
  end

  it "when first is larger than second" do
    calculate_intersection(0, 4, 1, 2).should == 1
  end

  it "with negative coordinates" do
    calculate_intersection(-100, -90, 1, 2).should == 0
    calculate_intersection(-100, -90, -95, -85).should == 5
    calculate_intersection(-10, 10, -5, 5).should == 10
    calculate_intersection(-10, 10, -5, 15).should == 15
  end
end

describe "#solution calculates intersection area" do
  it "when rectangles do not intersect" do
    solution(0, 0, 1, 1, 5, 5, 6, 6).should == 0
  end

  it "when rectangles are touching on one side" do
    solution(0, 0, 1, 1, 1, 0, 2, 1).should == 0
  end

  it "when rectangles are touching in one corner" do
    solution(0, 0, 1, 1, 1, 1, 2, 2).should == 0
  end

  it "when combination of negative and positive coordinates" do
    solution(-10, -10, 0, 0, -1, -1, 2, 2).should == 1
    solution(-10, -10, -5, 10, -20, 0, 20, 2).should == 10
  end

  it "indicates too large area" do
    solution(
        -2_147_483_648, -2_147_483_648, 2_147_483_647, 2_147_483_647,
        -2_147_483_648, -2_147_483_648, 2_147_483_647, 2_147_483_647).should == -1
  end

  it "for given example" do
    solution(0, 2, 5, 10, 3, 1, 20, 15).should == 16
  end
end
