require File.dirname(__FILE__) + "/../spec_helper"

module GitRevisionNumbers
  describe MasterCommitLibrarian do
    before :each do
      @repository = mock(Repository, :commits => nil)
      Repository.stub!(:new).and_return @repository
    end
  
    it "should initialize with a repository root" do
      Repository.should_receive(:new).with("foo").and_return @repository
      MasterCommitLibrarian.new("foo")
    end
    
    it "should initialize with a default repository root" do
      Repository.should_receive(:new).with(".").and_return @repository
      MasterCommitLibrarian.new
    end
  end
end