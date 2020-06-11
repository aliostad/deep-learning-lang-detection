require "spec_helper"

describe Document::ManageDocumentsController do
  describe "routing" do

    it "routes to #index" do
      get("/document/manage_documents").should route_to("document/manage_documents#index")
    end

    it "routes to #new" do
      get("/document/manage_documents/new").should route_to("document/manage_documents#new")
    end

    it "routes to #show" do
      get("/document/manage_documents/1").should route_to("document/manage_documents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/document/manage_documents/1/edit").should route_to("document/manage_documents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/document/manage_documents").should route_to("document/manage_documents#create")
    end

    it "routes to #update" do
      put("/document/manage_documents/1").should route_to("document/manage_documents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/document/manage_documents/1").should route_to("document/manage_documents#destroy", :id => "1")
    end

  end
end
