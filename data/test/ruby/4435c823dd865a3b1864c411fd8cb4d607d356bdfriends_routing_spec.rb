require "spec_helper"

describe Manage::FriendsController do
  describe "routing" do

    it "routes to #index" do
      get("/manage/friends").should route_to("manage/friends#index")
    end

    it "routes to #new" do
      get("/manage/friends/new").should route_to("manage/friends#new")
    end

    it "routes to #show" do
      get("/manage/friends/1").should route_to("manage/friends#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage/friends/1/edit").should route_to("manage/friends#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage/friends").should route_to("manage/friends#create")
    end

    it "routes to #update" do
      put("/manage/friends/1").should route_to("manage/friends#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/manage/friends/1").should route_to("manage/friends#destroy", :id => "1")
    end

  end
end
