require 'lib/watir-or.rb'
require 'spec/spec_helper'

describe "Read xls-repository" do
  context "Read first worksheet" do
    before(:all) do
      @repository = ObjectRepository::Repository.new("spec/test.xls", BrowserStub.new)
    end

    it "element with one attribute was readed" do
      one = ObjectRepository::RepositoryElement.new("one attribute", "text_field", [:name],
        ["test"], "Element with one attribute", @repository)
      @repository.get("one attribute").should == one
    end

    it "element with many attribute was readed" do
      many = ObjectRepository::RepositoryElement.new("many attributes", "select_list", [:text, :index],
        ["test text", 1], "Element with many attributes", @repository)
      @repository.get("many attributes").should == many
    end

    it "last element with many attribute was readed" do
      last_many = ObjectRepository::RepositoryElement.new("last element with many attributes", "image",
        [:name, :src], ["xxx", "path"], "Last element with many attributes", @repository)
      @repository.get("last element with many attributes").should == last_many
    end
  end

  context "Read special worksheet" do
    before(:all) do
      @repository = ObjectRepository::Repository.new("spec/test.xls", BrowserStub.new, :worksheet => "special worksheet")
    end

    it "should read element on special workheet" do
      first = ObjectRepository::RepositoryElement.new("first element", "text_field",
        [:name], ["awesome"], "First element on special worksheet", @repository)
      @repository.get("first element").should == first
    end
  end

  context "Read all worksheets" do
    before(:all) do
      @repository = ObjectRepository::Repository.new("spec/test.xls", BrowserStub.new, :worksheet => :all)
    end

    it "should read all elements on all workheets" do
      on_first_worksheet = ObjectRepository::RepositoryElement.new("one attribute", "text_field", [:name],
        ["test"], "Element with one attribute", @repository)
      on_special_worksheet = ObjectRepository::RepositoryElement.new("first element", "text_field",
        [:name], ["awesome"], "First element on special worksheet", @repository)
      @repository.get("one attribute").should == on_first_worksheet
      @repository.get("first element").should == on_special_worksheet
    end
  end

  it "duplicating of id" do
      lambda { ObjectRepository::Repository.new("spec/test_duplicating_id.xls", BrowserStub.new) }.should raise_error
  end
end