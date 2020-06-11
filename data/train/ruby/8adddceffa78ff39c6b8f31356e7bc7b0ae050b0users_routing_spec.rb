require "spec_helper"

describe Api::UsersController do
  describe "routing" do

    it "routes to #signup" do
      expect(post("/api/users/signup")).to route_to("api/users#signup")
    end

    it "routes to #login" do
      expect(post("/api/users/login")).to route_to("api/users#login")
    end

    it "routes to #me" do
      expect(get("/api/users/me")).to route_to("api/users#me")
    end

    it "routes to #reset_api_key (PUT)" do
      expect(put("/api/users/reset_api_key")).to route_to("api/users#reset_api_key")
    end

    it "routes to #reset_api_key (PATCH)" do
      expect(patch("/api/users/reset_api_key")).to route_to("api/users#reset_api_key")
    end

    it "routes to #change_password (PUT)" do
      expect(put("/api/users/change_password")).to route_to("api/users#change_password")
    end

    it "routes to #change_password (PATCH)" do
      expect(patch("/api/users/change_password")).to route_to("api/users#change_password")
    end

  end
end
