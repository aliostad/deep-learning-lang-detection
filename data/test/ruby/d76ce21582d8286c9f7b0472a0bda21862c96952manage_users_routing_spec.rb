require "rails_helper"

RSpec.describe ManageUsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/manage_users").to route_to("manage_users#index")
    end

    it "routes to #new" do
      expect(:get => "/manage_users/new").to route_to("manage_users#new")
    end

    it "routes to #show" do
      expect(:get => "/manage_users/1").to route_to("manage_users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/manage_users/1/edit").to route_to("manage_users#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/manage_users").to route_to("manage_users#create")
    end

    it "routes to #update" do
      expect(:put => "/manage_users/1").to route_to("manage_users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/manage_users/1").to route_to("manage_users#destroy", :id => "1")
    end

  end
end
