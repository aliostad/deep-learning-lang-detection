require 'spec_helper'

describe Admin::RepositoriesController do

  def mock_repository(stubs={})
    @mock_repository ||= mock_model(Repository, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all repositories as @repositories" do
      Repository.stub(:all) { [mock_repository] }
      get :index
      assigns(:repositories).should eq([mock_repository])
    end
  end

  describe "GET show" do
    it "assigns the requested repository as @repository" do
      Repository.stub(:find).with("37") { mock_repository }
      get :show, :id => "37"
      assigns(:repository).should be(mock_repository)
    end
  end

  describe "GET new" do
    it "assigns a new repository as @repository" do
      Repository.stub(:new) { mock_repository }
      get :new
      assigns(:repository).should be(mock_repository)
    end
  end

  describe "GET edit" do
    it "assigns the requested repository as @repository" do
      Repository.stub(:find).with("37") { mock_repository }
      get :edit, :id => "37"
      assigns(:repository).should be(mock_repository)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created repository as @repository" do
        Repository.stub(:new).with({'these' => 'params'}) { mock_repository(:save => true) }
        post :create, :repository => {'these' => 'params'}
        assigns(:repository).should be(mock_repository)
      end

      it "redirects to the created repository" do
        Repository.stub(:new) { mock_repository(:save => true) }
        post :create, :repository => {}
        response.should redirect_to(admin_repository_url(mock_repository))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved repository as @repository" do
        Repository.stub(:new).with({'these' => 'params'}) { mock_repository(:save => false) }
        post :create, :repository => {'these' => 'params'}
        assigns(:repository).should be(mock_repository)
      end

      it "re-renders the 'new' template" do
        Repository.stub(:new) { mock_repository(:save => false) }
        post :create, :repository => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested repository" do
        Repository.should_receive(:find).with("37") { mock_repository }
        mock_repository.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :repository => {'these' => 'params'}
      end

      it "assigns the requested repository as @repository" do
        Repository.stub(:find) { mock_repository(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:repository).should be(mock_repository)
      end

      it "redirects to the repository" do
        Repository.stub(:find) { mock_repository(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_repository_url(mock_repository))
      end
    end

    describe "with invalid params" do
      it "assigns the repository as @repository" do
        Repository.stub(:find) { mock_repository(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:repository).should be(mock_repository)
      end

      it "re-renders the 'edit' template" do
        Repository.stub(:find) { mock_repository(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested repository" do
      Repository.should_receive(:find).with("37") { mock_repository }
      mock_repository.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the repositories list" do
      Repository.stub(:find) { mock_repository }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_repositories_url)
    end
  end

end
