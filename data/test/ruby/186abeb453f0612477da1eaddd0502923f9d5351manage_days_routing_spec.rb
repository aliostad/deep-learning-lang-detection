require "spec_helper"

describe ManageDaysController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/manage_days" }.should route_to(:controller => "manage_days", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/manage_days/new" }.should route_to(:controller => "manage_days", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/manage_days/1" }.should route_to(:controller => "manage_days", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/manage_days/1/edit" }.should route_to(:controller => "manage_days", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/manage_days" }.should route_to(:controller => "manage_days", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/manage_days/1" }.should route_to(:controller => "manage_days", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/manage_days/1" }.should route_to(:controller => "manage_days", :action => "destroy", :id => "1")
    end

  end
end
