require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Manage::ProductsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "manage/products", :action => "index").should == "/manage/products"
    end

    it "should map #new" do
      route_for(:controller => "manage/products", :action => "new").should == "/manage/products/new"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/manage/products").should == {:controller => "manage/products", :action => "index"}
    end

    it "should generate params for #new" do
      params_from(:get, "/manage/products/new").should == {:controller => "manage/products", :action => "new"}
    end
  end
end

=begin
describe Manage::ProductsController do
  describe "route generation" do
    it "should map #show" do
      route_for(:controller => "manage/products", :action => "show", :id => 1).should == "/manage/products/1"
    end

    it "should map #edit" do
      route_for(:controller => "manage/products", :action => "edit", :id => 1).should == "/manage/products/1/edit"
    end

    it "should map #update" do
      route_for(:controller => "manage/products", :action => "update", :id => 1).should == "/manage/products/1"
    end

    it "should map #destroy" do
      route_for(:controller => "manage/products", :action => "destroy", :id => 1).should == "/manage/products/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #create" do
      params_from(:post, "/manage/products").should == {:controller => "manage/products", :action => "create"}
    end

    it "should generate params for #show" do
      params_from(:get, "/manage/products/1").should == {:controller => "manage/products", :action => "show", :id => "1"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/manage/products/1/edit").should == {:controller => "manage/products", :action => "edit", :id => "1"}
    end

    it "should generate params for #update" do
      params_from(:put, "/manage/products/1").should == {:controller => "manage/products", :action => "update", :id => "1"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/manage/products/1").should == {:controller => "manage/products", :action => "destroy", :id => "1"}
    end
  end
end
=end
