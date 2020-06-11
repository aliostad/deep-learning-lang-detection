require "spec_helper"

describe BusinessProcessProcessIndicatorAssignmentsController do
  describe "routing" do

    it "routes to #index" do
      get("/business_process_process_indicator_assignments").should route_to("business_process_process_indicator_assignments#index")
    end

    it "routes to #new" do
      get("/business_process_process_indicator_assignments/new").should route_to("business_process_process_indicator_assignments#new")
    end

    it "routes to #show" do
      get("/business_process_process_indicator_assignments/1").should route_to("business_process_process_indicator_assignments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/business_process_process_indicator_assignments/1/edit").should route_to("business_process_process_indicator_assignments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/business_process_process_indicator_assignments").should route_to("business_process_process_indicator_assignments#create")
    end

    it "routes to #update" do
      put("/business_process_process_indicator_assignments/1").should route_to("business_process_process_indicator_assignments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/business_process_process_indicator_assignments/1").should route_to("business_process_process_indicator_assignments#destroy", :id => "1")
    end

  end
end
