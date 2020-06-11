require 'app/models/chunk_processor.rb'
require 'app/models/chunk.rb'

describe Chunk do
  describe "when being created" do
    it "should split a string into lines" do
      string = stub
      lines = stub
      string.should_receive(:split).with("\n").and_return(lines)
      Chunk.new(string)
    end

    it "should not be processed" do
      Chunk.new("text").processed.should be_false
    end
  end

  describe "being asked if it's a note" do
    before :each do
      @chunk = Chunk.new("string")
    end

    it "should not know if it has no details" do
      @chunk.is_note.should be_false
    end

    it "should not be if it has details but is not a note" do
      @chunk.instance_variable_set(:@details, nil)
      @chunk.is_note.should be_false
    end

    it "should be if it has details and is a note" do
      @chunk.instance_variable_set(:@details, {:is_note => true})
      @chunk.is_note.should be_true
    end
  end

  describe "being asked if it's a highlight" do
    before :each do
      @chunk = Chunk.new("string")
    end

    it "should not know if it has no details" do
      @chunk.is_highlight.should be_false
    end

    it "should not be if it has details but is not a highlight" do
      @chunk.instance_variable_set(:@details, {})
      @chunk.is_highlight.should be_false
    end

    it "should be if it has details and is a highlight" do
      @chunk.instance_variable_set(:@details, {:is_highlight => true})
      @chunk.is_highlight.should be_true
    end
  end
end
