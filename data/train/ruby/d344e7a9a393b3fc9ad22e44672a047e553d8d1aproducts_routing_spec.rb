require "spec_helper"

describe Manage::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/manage/products").should route_to("manage/products#index")
    end

    it "routes to #new" do
      get("/manage/products/new").should route_to("manage/products#new")
    end

    it "routes to #show" do
      get("/manage/products/1").should route_to("manage/products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage/products/1/edit").should route_to("manage/products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage/products").should route_to("manage/products#create")
    end

    it "routes to #update" do
      put("/manage/products/1").should route_to("manage/products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/manage/products/1").should route_to("manage/products#destroy", :id => "1")
    end

  end
end
