require "spec_helper"

describe Golem::Chunk do

  context "when initialized with no data, but with full size" do
    before :each do
      @chunk = Golem::Chunk.new(0, 0, 0, 15, 127, 15, nil)
    end

    it "is a full chunk" do
      @chunk.should be_full_chunk
    end

    it "has 32768 :air entries" do
      blocks = @chunk.send(:blocks)
      blocks.should have(32768).entries
    end

    describe "#[]" do
      it "returns the block at the given location" do
        @chunk[0,0,0].should == :air
      end
    end

    describe "#[]=" do
      it "sets the block at the given location" do
        @chunk[0,0,0] = :dirt
        @chunk[0,0,0].should == :dirt
      end
    end

    describe "#find" do
      it "returns all the entries containing a particular type" do
        @chunk[0,0,0] = :dirt
        @chunk.find(:dirt).should == [[0,0,0]]
      end
    end

  end
end
