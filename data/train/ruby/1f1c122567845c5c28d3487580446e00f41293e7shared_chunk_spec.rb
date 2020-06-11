require_relative "../../spec_helper.rb"

describe Chunks::SharedChunk do
  describe "validation of name" do
    it "is required" do
      FactoryGirl.build(:shared_chunk, name: "").should_not be_valid
    end
    
    it "must be unique" do
      FactoryGirl.create(:shared_chunk, name: "Name!").should be_valid
      FactoryGirl.build(:shared_chunk, name: "Name!").should_not be_valid
    end
  end
  
  describe "unsharing" do
    before(:each) do
      @shared_chunk = FactoryGirl.create(:shared_chunk)
    end
    
    it "destroys itself" do
      @shared_chunk.unshare
      @shared_chunk.should be_destroyed
    end
    
    it "replaces any additional usages on pages with clones" do
      usage_1 = FactoryGirl.create(:chunk_usage, chunk: @shared_chunk.chunk)
      usage_2 = FactoryGirl.create(:chunk_usage, chunk: @shared_chunk.chunk)
      @shared_chunk.unshare
      usage_1.reload.chunk.should === @shared_chunk.chunk
      usage_2.reload.chunk.should_not === @shared_chunk.chunk
      usage_2.chunk.title.should == @shared_chunk.chunk.title
      usage_2.chunk.content.should == @shared_chunk.chunk.content
    end
  end
end