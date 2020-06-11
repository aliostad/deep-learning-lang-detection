require 'spec_helper'

describe DataChunk do
  let(:user) { User.make! }

  it "should be invalid without a name, user, storage and deployment" do
    data_chunk = DataChunk.new()
    data_chunk.should have(1).error_on(:name)
    data_chunk.should have(1).error_on(:user_id)
    data_chunk.should have(1).error_on(:deployment_id)
    data_chunk.errors.count.should == 3
    data_chunk.should_not be_valid
  end

  context "clone" do
    it "should be deep cloned, including all of its associations" do
      data_chunk = given_resources_for([:data_chunk])[:data_chunk]
      new_data_chunk = data_chunk.deep_clone
      DataChunk.last.should                == new_data_chunk
      new_data_chunk.name.should           == "Copy of #{data_chunk.name}"
      new_data_chunk.deployment.should     == data_chunk.deployment
      new_data_chunk.storage.should        == data_chunk.storage
      new_data_chunk.patterns.count.should == data_chunk.patterns.count
      new_data_chunk.should be_valid
    end

    it "should be deep cloned with a new name" do
      data_chunk = DataChunk.make(:user => user)
      new_data_chunk = data_chunk.deep_clone(:name => 'data_chunk2')
      new_data_chunk.name.should == "data_chunk2"
    end
  end

  it "should be invalid when storage belongs to another deployment" do
    data_chunk = given_resources_for([:data_chunk])[:data_chunk]
    data_chunk2 = given_resources_for([:data_chunk])[:data_chunk]

    data_chunk.storage = data_chunk2.storage
    data_chunk.should have(1).error_on(:storage)
    data_chunk.errors.count.should == 1
    data_chunk.should_not be_valid
  end

end