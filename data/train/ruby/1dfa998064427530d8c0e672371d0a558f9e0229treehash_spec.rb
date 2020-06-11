require 'spec_helper'

describe Treehash do
  it { should respond_to(:calculate_tree_hash) }
  specify { subject::MEGA_BYTE.should == 1024 * 1024 }

  context "for large strings" do
    it "should calculate the proper tree hash" do
      hash = Treehash::calculate_tree_hash('boo' * 1048576)
      hash.should == 'd53de7216088837ece12b81c0d233c18a2d0ef1f7e96b8f80cbf1b27f49dc4c5'
    end
  end

  context "for small strings" do
    it "should calculate the proper tree hash" do
      hash = Treehash::calculate_tree_hash "foo"
      hash.should == '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae'
    end

    it "should calculate the proper tree hash when given a file" do
      file = File.open File.join(File.dirname(__FILE__), 'fixtures', 'small_file')
      hash = Treehash::calculate_tree_hash file
      hash.should == '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae'
    end
  end

  it "should raise if improper data type" do
    expect { Treehash::calculate_tree_hash [] }.to raise_error
  end

  it "should handle empty strings" do
    Treehash::calculate_tree_hash('').should be_nil
  end
end
