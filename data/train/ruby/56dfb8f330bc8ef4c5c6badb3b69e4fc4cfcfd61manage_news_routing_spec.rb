require "spec_helper"

describe ManageNewsController do
  describe "routing" do

    it "routes to #index" do
      get("/manage_news").should route_to("manage_news#index")
    end

    it "routes to #new" do
      get("/manage_news/new").should route_to("manage_news#new")
    end

    it "routes to #show" do
      get("/manage_news/1").should route_to("manage_news#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage_news/1/edit").should route_to("manage_news#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage_news").should route_to("manage_news#create")
    end

    it "routes to #update" do
      put("/manage_news/1").should route_to("manage_news#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/manage_news/1").should route_to("manage_news#destroy", :id => "1")
    end

  end
end
