require 'coding_dojo_2'

describe CodingDojo2::Potter do
  it "costs nothing for an empty basket" do
    subject.calculate([]).should == 0
  end

  pending "should cost 8 for 1 book" do
    subject.calculate([0]).should == 8
    subject.calculate([1]).should == 8
    subject.calculate([2]).should == 8
    subject.calculate([3]).should == 8
    subject.calculate([4]).should == 8
  end

  pending "should discount nothing for identical books" do
    subject.calculate([0, 0]).should == 8 * 2
    subject.calculate([1, 1, 1]).should == 8 * 3
  end

  pending "should discount 5% for 2 different books" do
    subject.calculate([0, 1]).should == 8 * 2 * 0.95
  end

  pending "should discount 10% for 3 different books" do
    subject.calculate([0, 2, 4]).should == 8 * 3 * 0.9
  end

  pending "should discount 20% for 4 different books" do
    subject.calculate([0, 1, 2, 4]).should == 8 * 4 * 0.8
  end

  pending "should discount 25% for 5 different books" do
    subject.calculate([0, 1, 2, 3, 4]).should == 8 * 5 * 0.75
  end

  pending "should discount 5% for 2 different books out of 3" do
    subject.calculate([0, 0, 1]).should == 8 + (8 * 2 * 0.95)
  end

  pending "should discount 5% for 2 pairs of different books" do
    subject.calculate([0, 0, 1, 1]).should == 2 * (8 * 2 * 0.95)
  end

  pending "should discount 5% and 20% for 2 and 4 different books" do
    subject.calculate([0, 0, 1, 2, 2, 3])
      .should == (8 * 2 * 0.95) + (8 * 4 * 0.8)
  end

  pending "should discount 25% and nothing for 5 and 1 different books" do
    subject.calculate([0, 1, 1, 2, 3, 4])
      .should == 8 + (8 * 5 * 0.75)
  end

  pending "should be clever about grouping different books" do
    subject.calculate([0, 0, 1, 1, 2, 2, 3, 4])
      .should == 2 * (8 * 4 * 0.8)
    subject.calculate([
      0, 0, 0, 0, 0,
      1, 1, 1, 1, 1,
      2, 2, 2, 2,
      3, 3, 3, 3, 3,
      4, 4, 4, 4])
      .should == 3 * (8 * 5 * 0.75) + 2 * (8 * 4 * 0.8)
  end
end
