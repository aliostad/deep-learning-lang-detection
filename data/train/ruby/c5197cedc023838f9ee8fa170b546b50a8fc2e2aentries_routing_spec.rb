require "spec_helper"

describe Manage::News::EntriesController do
  describe "routing" do
    it "routes to #index" do
      get("/manage/news/draft/entries").should route_to("manage/news/entries#index", :folder => 'draft')
    end

    it "routes to #show" do
      get("/manage/news/entries/1").should route_to("manage/news/entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/manage/news/entries/1/edit").should route_to("manage/news/entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/manage/news/entries").should route_to("manage/news/entries#create")
    end
  end
end
