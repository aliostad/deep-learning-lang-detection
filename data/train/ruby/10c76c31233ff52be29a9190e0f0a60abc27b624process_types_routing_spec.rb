require "spec_helper"

describe ProcessTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/process").should route_to("process#index")
    end

    it "routes to #new" do
      get("/process/new").should route_to("process#new")
    end

    it "routes to #show" do
      get("/process/1").should route_to("process#show", :id => "1")
    end

    it "routes to #edit" do
      get("/process/1/edit").should route_to("process#edit", :id => "1")
    end

    it "routes to #create" do
      post("/process").should route_to("process#create")
    end

    it "routes to #update" do
      put("/process/1").should route_to("process#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/process/1").should route_to("process#destroy", :id => "1")
    end

  end
end
