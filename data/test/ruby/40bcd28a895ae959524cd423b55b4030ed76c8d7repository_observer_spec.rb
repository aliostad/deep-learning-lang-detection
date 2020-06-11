require 'spec_helper'

describe RepositoryObserver do
  context "log activities" do
    it "should log activities when user create or destroy repository" do
      repository = Repository.make!
      Activity.created_repository.where(:activityable_id => repository, :activityable_type => 'Repository').blank?.should be_false
      repository.destroy
      Activity.destroyed_repository.where(:activityable_id => repository, :activityable_type => 'Repository').blank?.should be_false
    end

    it "should log activities when user fork repository" do
      user = User.make!
      repository = Repository.make!
      new_repository = repository.fork_by!(user)
      Activity.forked_repository.where(:activityable_id => new_repository, :activityable_type => 'Repository').blank?.should be_false
    end
  end

  context "+- *_repositories_count" do
    it "public repository created or destroyed, +-1 public_repositories_count" do
      user = User.make!
      repository = Repository.make!(:user => user, :visibility => :public_repo)
      user.reload
      user.public_repositories_count.should == 1
      repository.destroy
      user.reload
      user.public_repositories_count.should == 0
    end

    it "private repository created or destroyed, +-1 private_repositories_count" do
      user = User.make!
      repository = Repository.make!(:user => user, :visibility => :private_repo)
      user.reload
      user.private_repositories_count.should == 1
      repository.destroy
      user.reload
      user.private_repositories_count.should == 0
    end

    it "when repository before update, if visibility changed, -1 (changed_visibility)_repositories_count" do
      user = User.make!
      repository = Repository.make!(:user => user, :visibility => :public_repo)
      user.reload
      user.public_repositories_count.should == 1
      user.private_repositories_count.should == 0
      repository.visibility = :private_repo
      repository.save
      user.reload
      user.public_repositories_count.should == 0
      user.private_repositories_count.should == 1
    end
  end

  it "generate git_repo_path" do
    user = User.make!
    repository = Repository.make!(:user => user)
    repository.git_repo_path.should be_kind_of(String)
    repository.git_repo_path.should match(/\/#{ user.username }\/#{ repository.name }\.git$/)
  end
  it "create bare git repository" do
    user = User.make!
    repository = Repository.make!(:user => user)
    repo = Grit::Repo.new repository.git_repo_path
    repo.commits.size.should == 1
    repo.commits.first.message.should == "init"
  end

end

