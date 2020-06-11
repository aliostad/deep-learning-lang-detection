require 'test_helper'

describe "API Versioning" do

  before do
    Post.destroy_all
    @posts = create_list(:post, 10)
    @api = Api::PostsApi.new
  end

  after do
    Post.destroy_all
  end

  describe "when creating an API" do

    it "must create a v1 API if v1 given" do
      api = Api::PostsApi.new('v1')
      api.wont_be_nil
      api.api_version.must_equal :v1
    end

    it "must create a v1.1 API if v1.1 given" do
      api = Api::PostsApi.new('v1_1')
      api.wont_be_nil
      api.api_version.must_equal :v1_1
    end

    it "must create a v1.1 API if no version given" do
      api = Api::PostsApi.new('')
      api.wont_be_nil
      api.api_version.must_equal :v1_1
    end

    it "must create a v1.1 API if a bad version given" do
      api = Api::PostsApi.new('dlk090@!')
      api.wont_be_nil
      api.api_version.must_equal :v1_1
    end

  end

  describe "when rendering json" do
    it "must render json" do
      @api.render(@posts).wont_be_nil
    end
  end

end