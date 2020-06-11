require 'spec_helper'

describe Player do
  let(:player) {subject}

  it "should calculate age before cutoff date" do
    player.birthdate = "01/05/2000"
    player.age.should == 11
  end

  it "should calculate age on cutoff date" do
    player.birthdate = "04/30/2000"
    player.age.should == 11
  end

  it "should calculate age after cutoff date" do
    player.birthdate = "05/30/2000"
    player.age.should == 10
  end

  it "should calculate age if birthdate is nil" do
    player.age.should be_nil
  end
end
