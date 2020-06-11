require "spec_helper"

describe "routing to api" do
  fixtures :users
  it "should route /api/:api_key/:id/:region/:size/:rotation/:file to api#index" do
    { :get => "/api/#{users(:testuser).api_key}/09064710/full/,120/0/native.png" }.should route_to(
      :controller => "api",
      :action => "index",
      :api_key => "#{users(:testuser).api_key}",
      :id => "09064710",
      :region => "full",
      :size => ",120",
      :rotation => "0",
      :file => "native",
      :format => "png"
    )
  end

  it "should route /api/:api_key/:id/:file to api#index" do
    { :get => "/api/#{users(:testuser).api_key}/09064710/native.png" }.should route_to(
      :controller => "api",
      :action => "index",
      :api_key => "#{users(:testuser).api_key}",
      :id => "09064710",
      :file => "native",
      :format => "png"
    )
  end

  it "should route /api to api#wiki" do
    { :get => "/api" }.should route_to(
      :controller => "api",
      :action => "wiki"
    )
  end

  it "should route /api/:api_key to api#wiki" do
    { :get => "/api/#{users(:testuser).api_key}" }.should route_to(
      :controller => "api",
      :action => "wiki",
      :api_key => "#{users(:testuser).api_key}"
    )
  end

  it "should not reach api with wrong number of parameters" do
    { :get => "/api/#{users(:testuser).api_key}/09064710/full/,120/0/native.png/12345" }.should route_to(
      :controller => "api", :action => "render_error", :path => "api/#{users(:testuser).api_key}/09064710/full/,120/0/native.png/12345")
    { :get => "/api/#{users(:testuser).api_key}/09064710/full/,120" }.should route_to(
      :controller => "api",:action => "render_error", :path => "api/#{users(:testuser).api_key}/09064710/full/,120")
    { :get => "/api/#{users(:testuser).api_key}/09064710" }.should route_to(
      :controller => "api",:action => "render_error", :path => "api/#{users(:testuser).api_key}/09064710")
  end

end
