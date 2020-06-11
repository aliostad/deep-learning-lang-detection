require 'spec_helper'

describe ChunksController do

  before(:each) do
    @chunk = Factory(:chunk)
  end

  def mock_label_selection
    LabelSelection.new.tap do |selection|
      selection.stub!(:source).and_return(@chunk.source)
      selection.stub!(:chunk).and_return(@chunk)

      user_session = mock(UserSession, :label_selection => selection)
      controller.stub!(:user_session).and_return(user_session)
    end
  end

  describe "GET show" do

    before(:each) do
      File.stub!(:exists?).and_return(true)
    end

    def self.it_should_return_chunk_in_format(format)
      it "should assign the requested chunk in #{format} format" do
        controller.should_receive(:send_file).with(@chunk.file, :type => format)
        get :show, :id => @chunk, :source_id => @chunk.source, :format => format.to_s
      end
    end

    it_should_return_chunk_in_format :wav
    it_should_return_chunk_in_format :ogg
    it_should_return_chunk_in_format :mp3

  end

  describe "GET new" do
    
    before(:each) do
      @label_selection = mock_label_selection
    end

    it "should use the LabelSelection to create Chunk" do
      get :new, :source_id => @label_selection.source
      assigns[:chunk].should == @label_selection.chunk
    end

    it "should not use the LabelSelection to create Chunk when nil" do
      @label_selection.stub!(:chunk)
      get :new, :source_id => @label_selection.source
      assigns[:chunk].should_not be_nil
    end

    it "should not use the LabelSelection when sources miss-match" do
      @label_selection.should_not_receive(:chunk)
      get :new, :source_id => Factory(:source)
    end

    it "should use source default chunk when no label selection" do
      @label_selection.stub!(:chunk)
      controller.stub!(:source).and_return(mock(Source, :default_chunk => @chunk))
      get :new, :source_id => Factory(:source)
      assigns[:chunk].should == @chunk
    end
    
  end

  describe "POST create" do

    before(:each) do
      @label_selection = mock_label_selection
    end
    
    it "should not use the LabelSelection to create Chunk" do
      @label_selection.should_not_receive(:chunk)
      post :create, :source_id => @chunk.source
    end

    it "should clear the LabelSelection when the created Chunk must selection labels" do
      @label_selection.stub!(:time_range).and_return(Range.new(15.minutes.ago, 10.minutes.ago))

      @label_selection.should_receive(:clear)
      post :create, :source_id => @chunk.source, :chunk => { 
        :begin => @label_selection.time_range.begin, :end => @label_selection.time_range.end 
      }
    end

  end

end
