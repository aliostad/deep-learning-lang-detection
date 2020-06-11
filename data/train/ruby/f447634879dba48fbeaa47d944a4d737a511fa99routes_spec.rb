require "spec_helper"

describe "routing to template" do
  fixtures :users
  it "should route /template/:api_key to api#index" do
    { :get => "/template/#{users(:testuser).api_key}" }.should route_to(
      :controller => "api",
      :action => "index",
      :api_key => "#{users(:testuser).api_key}"
    )
  end

  it "should route /template/:api_key/:issn to api#template" do
    { :get => "/template/#{users(:testuser).api_key}/09064710" }.should route_to(
      :controller => "api",
      :action => "template",
      :api_key => "#{users(:testuser).api_key}",
      :issn => "09064710"
    )
  end

  it "should route /template/:api_key/:issn/:issue_key to api#template" do
    { :get => "/template/#{users(:testuser).api_key}/09064710" }.should route_to(
      :controller => "api",
      :action => "template",
      :api_key => "#{users(:testuser).api_key}",
      :issn => "09064710"
    )
  end


  it "should route /api/:api_key/getIssueKeys/:issn to api#get_issue_keys" do
    { :get => "/api/#{users(:testuser).api_key}/getIssueKeys/09064710" }.should route_to(
      :controller => "api",
      :action => "get_issue_keys",
      :api_key => "#{users(:testuser).api_key}",
      :issn => "09064710"

    )
  end

  it "should route /api/:api_key/getArticles/:issue_keys to api#get_articles" do
    { :get => "/api/#{users(:testuser).api_key}/getArticles/09064710%7C000008%7C000062%7C000000%7C000001"  }.should route_to(
        :controller => "api",
        :action => "get_articles",
        :api_key => "#{users(:testuser).api_key}",
        :issue_key => "09064710|000008|000062|000000|000001"
      )
  end

  it "should route /api/:api_key/getNextKey/:issn/:issue_key => api#get_next_key" do
    { :get => "/api/#{users(:testuser).api_key}/getNextKey/09064710/09064710%7C000008%7C000062%7C000000%7C000001" }.should route_to(
        :controller => "api",
        :action => "get_next_key",
        :api_key => "#{users(:testuser).api_key}",
        :issn => "09064710",
        :issue_key => "09064710|000008|000062|000000|000001"
      )
  end
  
  it "should route api/:api_key/getPrevKey/:issn/:issue_key => api#get_prev_key" do
    { :get => "api/#{users(:testuser).api_key}/getPrevKey/09064710/09064710%7C000008%7C000062%7C000000%7C000001" }.should route_to(
      :controller => "api",
      :action => "get_prev_key",
      :api_key => "#{users(:testuser).api_key}",
      :issn => "09064710",
      :issue_key => "09064710|000008|000062|000000|000001"
      )
  end
    
    
end

