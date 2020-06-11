require 'spec_helper'

describe RepositoryModule do
  subject {
    RepositoryModule.instance(nil, Kindergarten::HeadGoverness.new(nil))
  }

  before(:each) do
    @project = Project.create(name: "test")
  end

  it "should have a repository purpose" do
    subject.class.purpose.should == :repository
  end

  it "should build a new repo for a project" do
    repository = subject.build(@project, name: "foo")
    repository.should be_kind_of(Repository)
    repository.project.should == @project
    repository.name.should == "foo"
  end

  it "should create a new repo for a project" do
    repository = subject.create(@project, name: "foo")
    repository.should be_kind_of(Repository)
    repository.project.should == @project
    repository.name.should == "foo"
  end
end

