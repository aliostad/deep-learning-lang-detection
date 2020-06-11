require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/my_model')

describe CacheProxy do
  before(:each) do
    MyModel.send(:include, CacheProxy)
    @model = MyModel.new
  end

  context "with the default options" do
    it "should cache the result" do
      repository = mock("repository")
      repository.expects(:fetch)

      @model.my_method({:repository => repository})
    end

    it "should expire the cache in 30 days" do
      repository = mock("repository")
      repository.expects(:fetch).with("my_key", :expires_in => 30.days)

      @model.my_method({:repository => repository})
    end
  end
  
  context "with user-specified options" do
    it "should bypass the cache storage if desired by the user" do
      repository = mock("repository")
      repository.expects(:fetch).never

      @model.my_method({:repository => repository, :cached => false})
    end

    it "should expire the cache using the range set by the user" do
      repository = mock("repository")
      repository.expects(:fetch).with("my_key", :expires_in => 3.days)

      @model.my_method({:repository => repository, :cache_expires_in => 3.days})
    end
  end
end