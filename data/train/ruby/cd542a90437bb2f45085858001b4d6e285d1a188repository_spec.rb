# encoding: utf-8
require 'helper'

module Repository
  describe "Repository" do
    before(:each) do
      #FIXME
      ::Repository[User].clear
      ::Repository[User].storage.clear
    end

    it "returns the repository for a class via []" do
      r1 = ::Repository[User]
      r1.should be_a(Repository)
      ::Repository[User].should == r1
    end

    it "can clear all" do
      ::Repository[User].store([User.new(:id => 1), User.new(:id => 2)])
      ::Repository[User].size.should == 2
      ::Repository.clear_all
      ::Repository[User].size.should == 0
    end
    
    it "can replace the repository for a given class" do
      new_repository = Repository.new(User)
      ::Repository[User] = new_repository
      ::Repository[User].should == new_repository
    end
  end

end
