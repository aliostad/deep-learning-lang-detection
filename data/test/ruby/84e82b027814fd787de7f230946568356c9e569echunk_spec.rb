require_relative "../../spec_helper.rb"

describe Chunks::Chunk do
  class Chunks::Chunk::WithTitle < Chunks::Chunk
    title "An Exciting Title!"
  end
  
  class Chunks::Chunk::WithoutTitle < Chunks::Chunk
  end
  
  it "allows a custom title to be provided" do        
    Chunks::Chunk::WithTitle.title.should == "An Exciting Title!"
    Chunks::Chunk::WithoutTitle.title.should == "Without Title"
  end
  
  it "provides a template name for render partial" do
    Chunks::Chunk::WithTitle.partial_name.should == "with_title"
  end
  
  it "raises an error if a container which does not exist is requested" do
    -> { FactoryGirl.create(:page).container(:not_real) }.should raise_error Chunks::Error
  end
  
  it "acts as list within its page and container" do
    our_page = FactoryGirl.create(:page)
    someone_elses_page = FactoryGirl.create(:page)    
    3.times do 
      FactoryGirl.create(:chunk_usage, page: our_page, container_key: :content)
      FactoryGirl.create(:chunk_usage, page: our_page, container_key: :other)
      FactoryGirl.create(:chunk_usage, page: someone_elses_page, container_key: :content)
    end
    our_page.reload
    our_page.container(:content).chunks.first.position.should == 1
    our_page.container(:content).chunks.second.position.should == 2
    our_page.container(:content).chunks.third.position.should == 3
  end
  
  describe "wrapping usage context when used within the scope of a page" do
    it "exposes container_key and position" do
      chunk = FactoryGirl.create(:chunk)
      chunk.usage_context = FactoryGirl.create(:chunk_usage, chunk: chunk, position: 10, container_key: "test_container")
      chunk.position.should == 10
      chunk.container_key.should == :test_container
    end
    
    it "raises an error when usage has not been set" do
      chunk = FactoryGirl.create(:chunk)
      -> { chunk.position }.should raise_error Chunks::Error
    end
  end
  
  describe "sharing between pages" do
    it "knows when it is shared" do
      chunk = FactoryGirl.create(:chunk)
      chunk.should_not be_shared
      chunk.share("Shared sidebar advert").should be_instance_of Chunks::SharedChunk
      chunk.should be_shared
    end
    
    it "cannot be shared more than once" do
      chunk = FactoryGirl.create(:chunk)
      shared = chunk.share("First successful share")
      chunk.share("Second attempted share").should == shared
    end
  end
end