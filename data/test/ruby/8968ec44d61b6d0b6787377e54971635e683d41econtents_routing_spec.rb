require File.dirname(__FILE__) + '/../spec_helper'

describe ContentsController do
  describe "route generation" do

    it "should map { :controller => 'contents', :action => 'index' } to /manage/contents" do
      route_for(:controller => "contents", :action => "index", :locale => 'en').should == "/en/manage/contents"
    end
  
    it "should map { :controller => 'contents', :action => 'new' } to /manage/contents/new" do
      route_for(:controller => "contents", :action => "new", :locale => 'en').should == "/en/manage/contents/new"
    end
  
    it "should map { :controller => 'contents', :action => 'show', :id => 1 } to /manage/contents/1" do
      route_for(:controller => "contents", :action => "show", :id => '1', :locale => 'en').should == "/en/manage/contents/1"
    end
  
    it "should map { :controller => 'contents', :action => 'edit', :id => 1 } to /manage/contents/1/edit" do
      route_for(:controller => "contents", :action => "edit", :id => '1', :locale => 'en').should == "/en/manage/contents/1/edit"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'contents', action => 'index' } from GET /manage/contents" do
      params_from(:get, "/manage/contents").should == {:controller => "contents", :action => "index"}
    end
  
    it "should generate params { :controller => 'contents', action => 'new' } from GET /manage/contents/new" do
      params_from(:get, "/manage/contents/new").should == {:controller => "contents", :action => "new"}
    end
  
    it "should generate params { :controller => 'contents', action => 'create' } from POST /manage/contents" do
      params_from(:post, "/manage/contents").should == {:controller => "contents", :action => "create"}
    end
  
    it "should generate params { :controller => 'contents', action => 'show', id => '1' } from GET /manage/contents/1" do
      params_from(:get, "/manage/contents/1").should == {:controller => "contents", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'contents', action => 'edit', id => '1' } from GET /manage/contents/1;edit" do
      params_from(:get, "/manage/contents/1/edit").should == {:controller => "contents", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'contents', action => 'update', id => '1' } from PUT /manage/contents/1" do
      params_from(:put, "/manage/contents/1").should == {:controller => "contents", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'contents', action => 'destroy', id => '1' } from DELETE /manage/contents/1" do
      params_from(:delete, "/manage/contents/1").should == {:controller => "contents", :action => "destroy", :id => "1"}
    end
  end
end
