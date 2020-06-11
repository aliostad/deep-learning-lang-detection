require_relative "../../spec_helper.rb"

describe Chunks::Container do  
  it "provides a readable title" do
    Chunks::Container.new(:test_container, *Chunks.config.chunks(:all)).title.should == "Test Container"
  end
    
  describe "configuring with available chunk types" do
    it "accepts available chunks as an array or varargs" do
      Chunks::Container.new(:test_container, Chunks::BuiltIn::Text, Chunks::BuiltIn::Html).available_chunk_types.size.should == 2
      Chunks::Container.new(:test_container, [Chunks::BuiltIn::Text, Chunks::BuiltIn::Html]).available_chunk_types.size.should == 2
    end
  
    it "raises an error if a key is not provided" do
      -> { Chunks::Container.new(*Chunks.config.chunks(:all)) }.should raise_error Chunks::Error
    end
  
    it "raises an error if something other than an available chunk type is provided" do
      -> { Chunks::Container.new(:test_container, "Not", "Chunks") }.should raise_error Chunks::Error
    end
  end
  
  it "finds all shared chunks which match the available chunk types" do
    html = FactoryGirl.create(:html_chunk)
    text = FactoryGirl.create(:text_chunk)
    FactoryGirl.create(:shared_chunk, chunk: text)
    FactoryGirl.create(:shared_chunk, chunk: html)
    FactoryGirl.create(:shared_chunk, chunk: FactoryGirl.create(:markdown_chunk))
    container = Chunks::Container.new(:test_container, Chunks::BuiltIn::Text, Chunks::BuiltIn::Html)
    container.should have(2).available_shared_chunks
    chunks = container.available_shared_chunks.map(&:chunk)
    chunks.should include text
    chunks.should include html
  end
  
  it "provides a list of valid chunks for rendering" do
    container = Chunks::Container.new(:test_container, Chunks.config.chunks(:all))
    container.chunks << valid_chunk = FactoryGirl.build(:chunk)
    container.chunks << invalid_chunk = FactoryGirl.build(:chunk, content: nil)
    container.valid_chunks.should include valid_chunk
    container.valid_chunks.should_not include invalid_chunk
  end
end