require 'spec_helper'

describe DistributionsController do
  login!
  
  def mock_distribution(stubs={})
    @mock_distribution ||= mock_model(Distribution, stubs).as_null_object
  end

  let(:repository) { create(:repository) }

  describe "GET 'index'" do
    let(:distribution) { create(:lucid, repository: repository) }

    before do
      repository.stub_chain(:distributions, :all).with([distribution])
      get :index, repository_id: repository.name
    end

    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should assign_to(:distributions).with([distribution]) }
    it { should assign_to(:repository).with(repository) }
  end

  describe "GET 'show'" do
    let(:distribution) { create(:lucid, repository: repository) }

    before do
      repository.stub_chain(:distributions, :find_by_name).with(distribution.id).and_return(distribution)
      get :show, repository_id: repository.name, id: distribution.codename
    end

    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should assign_to(:distribution).with(DistributionDecorator.decorate(distribution)) }
    it { should assign_to(:repository).with(repository) }
  end

  describe "GET 'new'" do
    let(:distribution) { repository.distributions.new }

    before do
      get :new, repository_id: repository.name
    end

    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should assign_to(:distribution) }
    it { should assign_to(:repository).with(repository) }
  end

  describe "POST 'create'" do
    context 'valid distribution' do
      let(:distribution) { mock_distribution(save: true) }

      before do
        Repository.stub(:find_by_name!).and_return(repository)

        repository.stub_chain(:distributions, :new).and_return(distribution)
        post :create, repository_id: repository.name, distribution: {}
      end

      it { should respond_with(:found) }
      it { should redirect_to repository_distribution_url(repository.name, distribution) }
      it { should assign_to(:distribution) }
      it { should assign_to(:repository).with(repository) }
      it { should set_the_flash.to "Distribution was successfully created." }
    end
    context 'invalid distribution' do
      let(:distribution) { mock_distribution(save: false) }

      before do
        Repository.stub(:find_by_name!).and_return(repository)
        repository.stub_chain(:distributions, :new).and_return(distribution)
        post :create, repository_id: repository.name, distribution: {}
      end

      it { should respond_with :ok }
      it { should render_template :new }
    end

  end

  describe "GET 'edit'" do
    let(:distribution) { create(:lucid, repository: repository) }

    before do
      # Repository.stub(:find).and_return(repository)
      repository.stub_chain(:distributions, :find_by_codename!).and_return(distribution)
      get :edit, repository_id: repository.name, id: distribution.codename
    end

    it { should respond_with :success }
    it { should render_template :edit }
    it { should assign_to :distribution }
    it { should assign_to(:repository).with(repository) }
  end

  describe "PUT 'update'" do

    context "valid attributes" do
      let(:distribution) { mock_distribution(save: true) }

      before do
        Repository.stub(:find_by_name!).and_return(repository)
        repository.stub_chain(:distributions, :find_by_codename!).and_return(distribution)
        put :update, repository_id: repository.name,
          id: distribution.codename,
          distribution: {}
      end

      it { should respond_with :found }
      it { should assign_to :distribution }
      it { should assign_to(:repository).with(repository) }
      it { should set_the_flash.to "Distribution was successfully updated."}
    end

    context "invalid attributes" do
      let(:distribution) { mock_distribution(save: false) }

      before do
        Repository.stub(:find_by_name!).and_return(repository)
        repository.stub_chain(:distributions, :find_by_codename!).and_return(distribution)

        put :update, repository_id: repository.name,
          id: distribution.codename,
          distribution: {}
      end

      it { should respond_with :ok }
      it { should render_template :edit }
      it { should assign_to :distribution }
      it { should assign_to(:repository).with(repository) }
    end
  end

  describe "DELETE 'destroy'" do
    let(:distribution) { create(:lucid, repository: repository) }

    before do
      Repository.stub(:find_by_name!).and_return(repository)
      repository.stub_chain(:distributions, :find_by_codename!).and_return(distribution)
      delete :destroy, repository_id: repository.name, id: distribution.codename
    end

    it { should respond_with(:redirect) }
    it { should redirect_to repository_distributions_url(repository) }
  end
end
