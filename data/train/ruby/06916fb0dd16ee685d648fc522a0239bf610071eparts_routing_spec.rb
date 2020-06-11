require File.dirname(__FILE__) + '/../spec_helper'

describe PartsController do
  describe "route generation" do

    it "should map { :controller => 'parts', :action => 'index' } to /manage/parts" do
      route_for(:controller => "parts", :action => "index", :locale => 'en').should == "/en/manage/parts"
    end
  
    it "should map { :controller => 'parts', :action => 'new' } to /manage/parts/new" do
      route_for(:controller => "parts", :action => "new", :locale => 'en').should == "/en/manage/parts/new"
    end
  
    it "should map { :controller => 'parts', :action => 'show', :id => 1 } to /manage/parts/1" do
      route_for(:controller => "parts", :action => "show", :id => '1', :locale => 'en').should == "/en/manage/parts/1"
    end
  
    it "should map { :controller => 'parts', :action => 'edit', :id => 1 } to /manage/parts/1/edit" do
      route_for(:controller => "parts", :action => "edit", :id => '1', :locale => 'en').should == "/en/manage/parts/1/edit"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'parts', action => 'index' } from GET /manage/parts" do
      params_from(:get, "/manage/parts").should == {:controller => "parts", :action => "index"}
    end
  
    it "should generate params { :controller => 'parts', action => 'new' } from GET /manage/parts/new" do
      params_from(:get, "/manage/parts/new").should == {:controller => "parts", :action => "new"}
    end
  
    it "should generate params { :controller => 'parts', action => 'create' } from POST /manage/parts" do
      params_from(:post, "/manage/parts").should == {:controller => "parts", :action => "create"}
    end
  
    it "should generate params { :controller => 'parts', action => 'show', id => '1' } from GET /manage/parts/1" do
      params_from(:get, "/manage/parts/1").should == {:controller => "parts", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'parts', action => 'edit', id => '1' } from GET /manage/parts/1;edit" do
      params_from(:get, "/manage/parts/1/edit").should == {:controller => "parts", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'parts', action => 'update', id => '1' } from PUT /manage/parts/1" do
      params_from(:put, "/manage/parts/1").should == {:controller => "parts", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'parts', action => 'destroy', id => '1' } from DELETE /manage/parts/1" do
      params_from(:delete, "/manage/parts/1").should == {:controller => "parts", :action => "destroy", :id => "1"}
    end
  end
end
