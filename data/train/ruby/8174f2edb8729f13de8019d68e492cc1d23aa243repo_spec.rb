require 'spec_helper'

describe Repository do

  context "new repo" do
    before :each do
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in 'sessions[username]', with: @user.username
      fill_in 'sessions[password]', with: @user.password
      click_button "Log In"
    end

    describe "successful sign in" do
      before :each do
        FactoryGirl.create(:tag)
        visit new_repository_path
        fill_in "repository_name", with: "repository"
        fill_in "repository_description", with: "repository description"
        page.check('tag[]')
        click_button "Create Repo"
        @repository = Repository.last
      end

      it 'can create a new repo and navigates to the first version of the new repository' do
        version = Version.where(:repository_id => @repository.id).first
        current_path.should eq repository_version_path(@repository, version)      
      end

      it 'creates a new version upon successful repo creation' do
        Version.last.repository_id.should eq @repository.id
      end

      it 'assigns first repo version as master version' do
        Version.last.id.should eq @repository.master_version_id
      end
    end

    describe "unsuccessful sign in" do
      before :each do
        visit new_repository_path
        @count = Repository.count
        fill_in "repository_description", with: "repository description"
        click_button "Create Repo"
      end

      it 'keeps user on same page if repository is not created' do
        current_path.should eq new_repository_path
      end

      it 'flashes an error if repository is not created' do
        expect {flash[:error]}.to_not be_nil
      end

      it 'does not save a repository if all fields are not completed' do
        @count.should eq Repository.count
      end
    end
  end

  context "show repository" do
    before :each do
      @user = FactoryGirl.create(:user)   
      @repository = FactoryGirl.build(:repository)
      @repository.creator = @user
      @repository.save
      @version = FactoryGirl.build(:version)
      @version.user = @user
      @version.repository = @repository
      @version.save
      @repository.master_version_id = @version.id
      @repository.save
      visit repository_path(@repository)
    end

    it "displays repository name" do 
      page.should have_content(@repository.name)
    end

    it "displays version user name" do
      page.should have_content(@user.username)
    end
  end
end