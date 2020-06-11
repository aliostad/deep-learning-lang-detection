require 'spec_helper'

describe Repository do

  context "valid_attribute" do
    it { should have_valid(:user).when( User.make! ) }
    it { should have_valid(:category).when( Category.make! ) }
#    it { should have_valid(:repo_files).when( [RepoFile.make!] ) }
    it { should have_valid(:issues).when( [Issue.make!] ) }
    it { should have_valid(:comments).when( [Comment.make!] ) }


    it { should have_valid(:name).when('test_123' * 2 ) }
    it { should_not have_valid(:name).when('s'*5, 's'*31, nil) }
    it { should_not have_valid(:describtion).when('s'*1001) }
    it { should have_valid(:visibility).when('public_repo', 'private_repo' ) }
    it { should_not have_valid(:visibility).when('test') }

  end

  context "validates" do
    it "uniq name on one user_id" do
      user = User.make!
      Repository.make!(:name => "abc" * 5, :user => user)
      lambda { Repository.make!(:name => "abc" * 5, :user => user) }.should raise_error()
      lambda { Repository.make!(:name => "def" * 5, :user => user) }.should_not raise_error()
    end
  end

  context "associations" do
    it { subject.association(:follower_followed).should be_a(ActiveRecord::Associations::HasManyAssociation) }
    it { subject.association(:watchers).should be_a(ActiveRecord::Associations::HasManyThroughAssociation) }
  end

  context "fork by user" do
    let(:user) { User.make! }

    it "has forked_by_user?" do
      repository_a = Repository.make!
      new_repository = repository_a.fork_by!(user)
      repository_a.forked_by_user?(user).should be_true
    end

    it "if forked, return forked repository" do
      repository_a = Repository.make!
      new_repository = repository_a.fork_by!(user)
      repository_a.fork_by!(user).should == new_repository
    end

    it "should fork by user, and forked repository.root eq root repository" do
      repository_a = Repository.make!
      new_repository = repository_a.fork_by!(user)
      new_repository.parent.id.should eq(repository_a.id)
    end

    it "repository.root forks_count should +1" do
      repository_a = Repository.make!
      repository_b = repository_a.fork_by!(user)
      repository_a.reload.forks_count.should == 1
      repository_c = repository_b.fork_by!(User.make!)
      repository_a.reload.forks_count.should == 2
    end

    it "has forks method" do
      repository_a = Repository.make!
      new_repository = repository_a.fork_by!(user)
      repository_a.forks.should eq([new_repository])
      repository_a.forks.size.should == 1
    end

    it "has git_repo method" do
      repository = Repository.make!
      repository.git_repo.should be_kind_of(Grit::Repo)
    end

    it "has visibility_prefix method" do
      repository = Repository.make!(:visibility => :public_repo)
      repository.visibility_prefix.should == "public"
    end

    it "has forked_by_user method" do
      pending
    end

    it "has forked_by_user? method" do
      pending
    end

    it "when category_id blank, build category_id with Category.first" do
      pending
    end
  end

end
# == Schema Information
#
# Table name: repositories
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  category_id      :integer
#  ancestry         :string(255)
#  name             :string(255)
#  describtion      :text
#  visibility       :string(255)
#  features         :string(255)
#  git_repo_path    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  watchers_count   :integer         default(0)
#  repo_files_count :integer         default(0)
#  issues_count     :integer         default(0)
#  comments_count   :integer         default(0)
#  forks_count      :integer         default(0)
#  deleted_at       :datetime
#

