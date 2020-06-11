require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "route generation" do

    it "should map { :controller => 'pages', :action => 'index' } to /manage/pages" do
      route_for(:controller => "pages", :action => "index", :locale => 'en').should == "/en/manage/pages"
    end
  
    it "should map { :controller => 'pages', :action => 'new' } to /manage/pages/new" do
      route_for(:controller => "pages", :action => "new", :locale => 'en').should == "/en/manage/pages/new"
    end
  
    it "should map { :controller => 'pages', :action => 'show', :id => 1 } to /manage/pages/1" do
      route_for(:controller => "pages", :action => "show", :id => '1', :locale => 'en').should == "/en/manage/pages/1"
    end
  
    it "should map { :controller => 'pages', :action => 'edit', :id => 1 } to /manage/pages/1/edit" do
      route_for(:controller => "pages", :action => "edit", :id => '1', :locale => 'en').should == "/en/manage/pages/1/edit"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'pages', action => 'index' } from GET /manage/pages" do
      params_from(:get, "/manage/pages").should == {:controller => "pages", :action => "index"}
    end
  
    it "should generate params { :controller => 'pages', action => 'new' } from GET /manage/pages/new" do
      params_from(:get, "/manage/pages/new").should == {:controller => "pages", :action => "new"}
    end
  
    it "should generate params { :controller => 'pages', action => 'create' } from POST /manage/pages" do
      params_from(:post, "/manage/pages").should == {:controller => "pages", :action => "create"}
    end
  
    it "should generate params { :controller => 'pages', action => 'show', id => '1' } from GET /manage/pages/1" do
      params_from(:get, "/manage/pages/1").should == {:controller => "pages", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'pages', action => 'edit', id => '1' } from GET /manage/pages/1;edit" do
      params_from(:get, "/manage/pages/1/edit").should == {:controller => "pages", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'pages', action => 'update', id => '1' } from PUT /manage/pages/1" do
      params_from(:put, "/manage/pages/1").should == {:controller => "pages", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'pages', action => 'destroy', id => '1' } from DELETE /manage/pages/1" do
      params_from(:delete, "/manage/pages/1").should == {:controller => "pages", :action => "destroy", :id => "1"}
    end
  end
end
