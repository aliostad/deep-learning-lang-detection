#coding: utf-8
require 'spec_helper'
require 'grit'
require 'fileutils'

describe Repository do
  before(:each) do
    user = create(:user)
    @repository = create(:repository, user:user)
  end
  after(:each) do
    @repository.destroy
  end
  it "ownerはUserを返すこと" do
    @repository.owner.should be_an_instance_of(User)
    @repository.owner.should_not be_nil
  end

  it "ownerに別のUserを代入できること" do
    user = create(:user)
    @repository.owner = user
    @repository.owner.should == user
  end

  it "originalのとき" do
    @repository.original?.should == true
    @repository.forked?.should == false
  end
  it "forkedのとき" do
    @repository.forked_from = 1
    @repository.original?.should == false
    @repository.forked?.should == true
  end

  it "working_dirは文字列を返すこと" do
    @repository.working_dir.should == "#{Rails.root}/public/repositories/#{@repository.name}"
  end

  it "repoでGrit::Repoオブジェクトを得られること" do
    @repository.repo.should be_instance_of(Grit::Repo)
    @repository.repo.should_not be_nil
  end

  it "git initでGrit::Repoオブジェクトを作成すること" do
    repository = build(:repository, name:"Repo2")
    repository.git_init.should be_instance_of(Grit::Repo)
    FileUtils.rm_r(repository.working_dir, {force:true})
  end

  it "mkdirで新しくディレクトリを作ること" do
    repository = build(:repository, name:"HOGEHOGEHOGE")
    lambda{ Dir.open(repository.working_dir) }.should raise_error(Errno::ENOENT)
    repository.mkdir
    dir = Dir.open(repository.working_dir)
    dir.should be_instance_of(Dir)
    dir.close
    Dir.rmdir(repository.working_dir)
  end

  describe "current_branch" do
    before do
      @dev = @repository.master.checkout(name:"dev")
      @dev.save
    end

    it "should return 'master'" do
      @repository.current_branch.should == "master"
    end

    it "should return 'dev'" do
      @repository.lock do
        @repository.checkout_to("dev")
        @repository.current_branch.should == "dev"
      end
    end
  end

end
