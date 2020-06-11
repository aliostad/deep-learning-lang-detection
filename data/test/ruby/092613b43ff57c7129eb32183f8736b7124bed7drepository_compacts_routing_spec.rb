require "spec_helper"

describe RepositoryCompactsController do
  describe "routing" do

    it "routes to #index" do
      get("/repository_compacts").should route_to("repository_compacts#index")
    end

    it "routes to #new" do
      get("/repository_compacts/new").should route_to("repository_compacts#new")
    end

    it "routes to #show" do
      get("/repository_compacts/1").should route_to("repository_compacts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/repository_compacts/1/edit").should route_to("repository_compacts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/repository_compacts").should route_to("repository_compacts#create")
    end

    it "routes to #update" do
      put("/repository_compacts/1").should route_to("repository_compacts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/repository_compacts/1").should route_to("repository_compacts#destroy", :id => "1")
    end

  end
end
