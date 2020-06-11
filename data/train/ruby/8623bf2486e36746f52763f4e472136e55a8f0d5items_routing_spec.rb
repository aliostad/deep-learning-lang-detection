require "spec_helper"

describe Manage::ItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/manage/items").should route_to("manage/items#index")
    end

    it "routes to #new" do
      get("/manage/items/new").should route_to("manage/items#new")
    end

    it "routes to #show" do
      get("/manage/items/1").should route_to("manage/items#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage/items/1/edit").should route_to("manage/items#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage/items").should route_to("manage/items#create")
    end

    it "routes to #update" do
      put("/manage/items/1").should route_to("manage/items#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/manage/items/1").should route_to("manage/items#destroy", :id => "1")
    end

  end
end
