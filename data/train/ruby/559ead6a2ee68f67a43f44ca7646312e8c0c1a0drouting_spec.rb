require 'spec_helper'

describe "routing" do
  describe "homes" do
    it "routes homes" do
      get("/homes"                      ).should route_to("homes#index"  )
      get("/homes/coming_soon"          ).should route_to("homes#coming_soon"  )
    end
  end

  describe "user_sessions" do
    it "routes session resource" do
      post("/user_session"      ).should route_to("user_sessions#create" )
      get("/user_session/new"   ).should route_to("user_sessions#new"    )
      delete("/user_session"    ).should route_to("user_sessions#destroy")
    end
  end

  describe "password_reset" do
    it "routes password_reset resource" do
      post("/password_reset"    ).should route_to("password_resets#create")
      get("/password_reset/new" ).should route_to("password_resets#new"   )
      get("/password_reset/edit").should route_to("password_resets#edit"  )
      put("/password_reset"     ).should route_to("password_resets#update")
    end
  end

  describe "manage categories" do
    it "routes manage categories" do
      get("/manage_categories"              ).should route_to("manage_categories#index"  )
      get("/manage_categories/new"          ).should route_to("manage_categories#new"  )
      post("/manage_categories"             ).should route_to("manage_categories#create"  )
      get("/manage_categories/1/edit"       ).should route_to(controller: "manage_categories", action: "edit", id: "1")
      put("/manage_categories/1"            ).should route_to(controller: "manage_categories", action: "update", id: "1")
      delete("/manage_categories/1"         ).should route_to(controller: "manage_categories", action: "destroy", id: "1")
    end
  end

  describe "manage products" do
    it "routes manage products" do
      get("/manage_products"              ).should route_to("manage_products#index"  )
      get("/manage_products/new"          ).should route_to("manage_products#new"  )
      post("/manage_products"             ).should route_to("manage_products#create"  )
      get("/manage_products/1"            ).should route_to(controller: "manage_products", action: "show", id: "1")
      get("/manage_products/1/edit"       ).should route_to(controller: "manage_products", action: "edit", id: "1")
      put("/manage_products/1"            ).should route_to(controller: "manage_products", action: "update", id: "1")
      delete("/manage_products/1"         ).should route_to(controller: "manage_products", action: "destroy", id: "1")
    end
  end

  describe "show products" do
    it "routes products" do
      get("/products"              ).should route_to("products#index" )
      get("/products/new"          ).should route_to("products#new"  )
      post("/products"             ).should route_to("products#create"  )
      get("/products/1"            ).should route_to(controller: "products", action: "show", id: "1")
      get("/products/1/edit"       ).should route_to(controller: "products", action: "edit", id: "1")
      put("/products/1"            ).should route_to(controller: "products", action: "update", id: "1")
      delete("/products/1"         ).should route_to(controller: "products", action: "destroy", id: "1")
      get("/products/1/show_porducts").should route_to(controller: "products", action: "show_porducts", id: "1")
    end
  end

  describe "contacts" do
    it "routes contacts" do
      get("/contacts"                      ).should route_to("contacts#index"  )
      post("/contacts/create"              ).should route_to("contacts#create"  )
    end
  end
end
