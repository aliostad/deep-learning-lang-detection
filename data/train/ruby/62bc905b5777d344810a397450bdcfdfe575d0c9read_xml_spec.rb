require 'lib/watir-or.rb'
require 'spec_helper'

describe "Read xml-repository" do
  before(:all) do
    @repository = ObjectRepository::Repository.new("spec/test.xml", BrowserStub.new)
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

  it "child element was readed" do
    child = ObjectRepository::RepositoryElement.new("with parent", "div", [:index, :parent],
      [3, "parent element"], "Element with parent", @repository)
    @repository.get("with parent").should == child
  end
end