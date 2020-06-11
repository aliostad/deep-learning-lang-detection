require "spec_helper"

describe Manage::BlogsController do
  describe "routing" do

    it "routes to #index" do
      get("/manage/blogs").should route_to("manage/blogs#index")
    end

    it "routes to #new" do
      get("/manage/blogs/new").should route_to("manage/blogs#new")
    end

    it "routes to #show" do
      get("/manage/blogs/1").should route_to("manage/blogs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage/blogs/1/edit").should route_to("manage/blogs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage/blogs").should route_to("manage/blogs#create")
    end

    it "routes to #update" do
      put("/manage/blogs/1").should route_to("manage/blogs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/manage/blogs/1").should route_to("manage/blogs#destroy", :id => "1")
    end

  end
end
