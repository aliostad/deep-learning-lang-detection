require 'spec_helper'

describe RepositoriesController do
  let(:authorized_user) { create :user }
  describe 'GET #show' do
    it 'assigns the requested repository to @repository' do
      sign_in authorized_user
      repository = create(:repository)

      get :show, id: repository

      assigns(:repository).should eq(repository)
    end

    it 'renders the :show template' do
      sign_in authorized_user
      get :show, id: create(:repository)

      response.should render_template :show
    end
  end

  describe 'GET #index' do
    it 'assigns a new repository to @repository' do
      sign_in authorized_user
      create_list(:repository, 9)
      get :index

      repositories = assigns(:repositories)
      repositories.count.should == Repository.count
      repositories.collect(&:id).should == Repository.all.collect(&:id)
    end
  end 
end
