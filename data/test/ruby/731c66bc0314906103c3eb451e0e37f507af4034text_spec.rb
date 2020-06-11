require_relative "../../../spec_helper.rb"

describe Chunks::BuiltIn::Text do
  describe "validation" do
    it "requires content" do
      chunk = Chunks::BuiltIn::Text.new
      chunk.should_not be_valid
      chunk.content = "Some text"
      chunk.should be_valid
    end
    
    it "requires a title if content is expandable" do
      chunk = Chunks::BuiltIn::Text.new(content: "Some text", expandable: "1")
      chunk.should_not be_valid
      chunk.title = "Click me to expand"
      chunk.should be_valid
    end
  end
end