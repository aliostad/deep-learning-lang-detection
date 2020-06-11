require "spec_helper"

describe Manage::CalendarsController do
  describe "routing" do

    it "routes to #index" do
      get("/manage/calendars").should route_to("manage/calendars#index")
    end

    it "routes to #new" do
      get("/manage/calendars/new").should route_to("manage/calendars#new")
    end

    it "routes to #show" do
      get("/manage/calendars/1").should route_to("manage/calendars#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage/calendars/1/edit").should route_to("manage/calendars#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage/calendars").should route_to("manage/calendars#create")
    end

    it "routes to #update" do
      put("/manage/calendars/1").should route_to("manage/calendars#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/manage/calendars/1").should route_to("manage/calendars#destroy", :id => "1")
    end

  end
end
