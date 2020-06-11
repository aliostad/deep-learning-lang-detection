require 'lib/watir-or.rb'
require 'spec/browser_stub'
require 'spec/spec_helper'

describe "WatirObjectBuilder" do
  before(:all) do
    @browser_stub = BrowserStub.new
    @repository = ObjectRepository::Repository.new("spec/test.xls", @browser_stub)
  end

  it "build watir object properly" do
    element = @repository.get('many attributes')
    built = ObjectRepository::WatirObjectBuilder.build_element(element, @repository)
    built.should == 'select_list(:index=>1, :text=>"test text")'
  end

  it "build element with regexp" do
    element = @repository.get('with regexp what')
    built = ObjectRepository::WatirObjectBuilder.build_element(element, @repository)
    built.should == 'text_field(:text,/regexp/)'
  end

  context "hierarchy" do
    it "watir object which has one parent" do
      element = @repository.get('with parent')
      built = ObjectRepository::WatirObjectBuilder.build_element(element, @repository)
      built.should == 'div(:index,1).div(:index,3)'
    end

    it "2 level" do
      element = @repository.get('2 level hierarchy')
      built = ObjectRepository::WatirObjectBuilder.build_element(element, @repository)
      built.should == 'div(:index,1).div(:index,3).div(:index,5)'
    end
  end
end