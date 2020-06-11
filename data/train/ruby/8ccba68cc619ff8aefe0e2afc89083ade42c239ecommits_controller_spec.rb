require 'spec_helper'

describe CommitsController do

  before do
    @fake_repository_data = FakeRepository.new.repository_metadata
    @repository = Repository.update_or_create_from_github_push(@fake_repository_data)
  end

  describe "GET 'index'" do

    it "should be successful" do
      get :index, :repository_id => @repository.id
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      commit = @repository.commits.first
      get :show, :repository_id => @repository.id, :id => commit.id
      response.should be_success
    end
  end
end
