require File.dirname(__FILE__) + '/../spec_helper'

describe Repository do
  before(:each) do
    @repository = new_repos
  end
  
  def new_repos(opts={})
    Repository.new({
      :name => "foo",
      :project => projects(:johans),
      :user => users(:johan)
    }.merge(opts))
  end
  
  it "should have valid associations" do
    @repository.should have_valid_associations
  end

  it "should have a name to be valid" do
    @repository.name = nil
    @repository.should_not be_valid
  end
  
  it "should only accept names with alphanum characters in it" do
    @repository.name = "foo bar"
    @repository.should_not be_valid
    
    @repository.name = "foo!bar"
    @repository.should_not be_valid
    
    @repository.name = "foobar"
    @repository.should be_valid
    
    @repository.name = "foo42"
    @repository.should be_valid
  end
  
  it "has a unique name within a project" do
    @repository.save
    repos = new_repos(:name => "FOO")
    repos.should_not be_valid
    repos.should have(1).error_on(:name)
    
    new_repos(:project => projects(:moes)).should be_valid
  end
  
  it "sets itself as mainline if it's the first repository for a project" do
    projects(:johans).repositories.destroy_all
    projects(:johans).repositories.reload.size.should == 0
    @repository.save
    @repository.mainline?.should == true
  end
  
  it "doesnt set itself as mainline if there's more than one repos" do
    @repository.save
    @repository.mainline?.should == false
  end
  
  it "has a gitdir name" do
    @repository.gitdir.should == "#{@repository.project.slug}/foo.git"
  end
  
  it "has a push url" do
    @repository.push_url.should == "git@gitorious.org:#{@repository.project.slug}/foo.git"
  end
  
  it "has a clone url" do
    @repository.clone_url.should == "git://gitorious.org/#{@repository.project.slug}/foo.git"
  end
  
  it "should assign the creator as a comitter on create" do 
    @repository.save!
    @repository.reload
    @repository.committers.should include(users(:johan))
  end
  
  it "has a full repository_path" do
    expected_dir = File.expand_path(File.join(GitoriousConfig["repository_base_path"], 
      projects(:johans).slug, "foo.git"))
    @repository.full_repository_path.should == expected_dir
  end
  
  it "inits the git repository" do
    Repository.git_backend.should_receive(:create).with(@repository.full_repository_path).and_return(true)
    Repository.create_git_repository(@repository.gitdir)
  end
  
  it "clones a git repository" do
    source = repositories(:johans)
    target = @repository
    Repository.git_backend.should_receive(:clone).with(target.full_repository_path, 
      source.full_repository_path).and_return(true)
    Repository.clone_git_repository(target.gitdir, source.gitdir)
  end
  
  it "deletes a repository" do
    Repository.git_backend.should_receive(:delete!).with(@repository.full_repository_path).and_return(true)
    Repository.delete_git_repository(@repository.gitdir)
  end
  
  it "knows if has commits" do
    @repository.git_backend.should_receive(:repository_has_commits?).and_return(true)
    @repository.has_commits?.should == true
  end
  
  it "should build a new repository by cloning another one" do
    repos = Repository.new_by_cloning(@repository)
    repos.parent.should == @repository
    repos.project.should == @repository.project
  end
  
  it "suggests a decent name for a cloned repository bsed on username" do
    repos = Repository.new_by_cloning(@repository, username="johan")
    repos.name.should == "johans-#{repos.parent.name}-clone"
    repos = Repository.new_by_cloning(@repository, username=nil)
    repos.name.should == nil
  end
  
  it "has it's name as its to_param value" do
    @repository.save
    @repository.to_param.should == @repository.name
  end
  
  it "finds a repository by name or raises" do
    Repository.find_by_name!(repositories(:johans).name).should == repositories(:johans)
    proc{
      Repository.find_by_name!("asdasdasd")
    }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "xmlilizes git paths as well" do
    @repository.to_xml.should include("<gitdir>")
    @repository.to_xml.should include("<clone-url>")
    @repository.to_xml.should include("<push-url>")
  end
  
  it "adds an user as a comitter to itself" do
    @repository.save
    users(:moe).can_write_to?(@repository).should == false
    @repository.add_committer(users(:moe))
    users(:moe).can_write_to?(@repository).should == true
  end
  
  it "creates a Task on create and update" do
    proc{
      @repository.save!
    }.should change(Task, :count)
    task = Task.find(:first, :conditions => ["target_class = 'Repository'"], :order => "id desc")
    task.command.should == "create_git_repository"
    task.arguments.size.should == 1
    task.arguments.first.should match(/#{@repository.gitdir}$/)
    task.target_id.should == @repository.id
  end
  
  it "creates a clone task if there's a parent" do
    proc{
      @repository.parent = repositories(:johans)
      @repository.save!
    }.should change(Task, :count)
    task = Task.find(:first, :conditions => ["target_class = 'Repository'"], :order => "id desc")
    task.command.should == "clone_git_repository"
    task.arguments.size.should == 2
    task.arguments.first.should match(/#{@repository.gitdir}$/)
    task.target_id.should == @repository.id
  end
  
  it "creates a Task on destroy" do
    @repository.save!
    proc{
      @repository.destroy
    }.should change(Task, :count)
    task = Task.find(:first, :conditions => ["target_class = 'Repository'"], :order => "id desc")
    task.command.should == "delete_git_repository"
    task.arguments.size.should == 1
    task.arguments.first.should match(/#{@repository.gitdir}$/)
  end
  
  it "has one recent commit" do
    @repository.save!
    repos_mock = mock("Git mock")
    commit_mock = mock("Git::Commit mock")
    repos_mock.should_receive(:log).with(1).and_return(commit_mock)
    commit_mock.should_receive(:first).and_return(commit_mock)
    Git.should_receive(:bare).with(@repository.full_repository_path).and_return(repos_mock)
    @repository.stub!(:has_commits?).and_return(true)
    @repository.last_commit.should == commit_mock
  end
  
  describe "observers" do
    it "sends an email to the admin if there's a parent" do
      Mailer.should_receive(:deliver_new_repository_clone).with(@repository).and_return(true)
      @repository.parent = repositories(:johans)
      @repository.save!
    end
    
    it "does not send an email to the admin if there's not a parent parent" do
      Mailer.should_not_receive(:deliver_new_repository_clone).with(@repository).and_return(true)
      @repository.parent = nil
      @repository.save!
    end
  end
end
