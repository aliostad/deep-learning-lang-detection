require File.dirname(__FILE__)+'/spec_helper'

describe FlatHash::Repository do
  it "should raise exception when no vcs repository is detected" do
    in_temp_directory do
      with_repository do |repository|
        repository.should_not be_vcs_supported
      end
    end
  end
end

shared_examples_for "a repository" do
  it "should have an initially empty history" do
    in_vcs_working_directory do |vcs|
      with_repository do |repository|
        repository.changesets.should == []
      end
    end
  end

  it 'should detect additions' do
    in_vcs_working_directory do |vcs|
      with_repository do |repository|
        repository['entry'] = {'key' => 'value'}
        vcs.addremovecommit 'first commit'
        repository.changesets.size.should == 1
      end
    end
  end

  it 'should detect deletions' do
    in_vcs_working_directory do |vcs|
      with_repository do |repository|
        repository['entry1'] = {'key' => 'value'}
        vcs.addremovecommit 'added entry1'

        repository['entry2'] = {'key' => 'value'}
        vcs.addremovecommit 'added entry2'

        repository['entry1'] = {'key' => 'a different value'}
        vcs.addremovecommit 'updated entry1'

        repository.destroy 'entry1'
        vcs.addremovecommit 'removed entry1'

        repository.changesets.size.should == 4
      end
    end
  end

  it 'should detect modifications' do
    in_vcs_working_directory do |vcs|
      with_repository do |repository|
        repository['entry'] = {'key' => 'value'}
        vcs.addremovecommit 'first commit'
        repository['entry'] = {'key' => 'value2'}
        vcs.addremovecommit 'next commit'
        repository.changesets.size.should == 2
      end
    end
  end
end

describe FlatHash::Repository, 'git' do
  it_should_behave_like "a repository"

  def vcs_class
    FlatHash::Git
  end
end

describe FlatHash::Repository, 'hg' do
  it_should_behave_like "a repository"

  def vcs_class
    FlatHash::Hg
  end
end