if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    match 'projects/:project_id/boards/:board_id/manage', :to => 'boards_watchers#manage', :via => [:get, :post]
    match 'projects/:project_id/boards/:board_id/manage_topic', :to => 'boards_watchers#manage_topic', :via => [:get, :post]
    match 'projects/:project_id/boards/:board_id/manage_topic_remote', :to => 'boards_watchers#manage_topic_remote', :via => [:get, :post]
    match 'projects/:project_id/manage_wiki/:id', :to => 'boards_watchers#manage_wiki', :via => [:get, :post]
    match 'boards_watchers/issues_watchers_bulk', :to => 'boards_watchers#issues_watchers_bulk', :via => [:get, :post]
    match 'boards_watchers/watch_bulk_issues', :to => 'boards_watchers#watch_bulk_issues', :via => [:get, :post]
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.with_options :controller => 'boards_watchers' do |bw_routes|
      bw_routes.with_options :conditions => {:method => :get} do |bw_views|
        bw_views.connect 'projects/:project_id/boards/:board_id/manage', :action => 'manage'
        bw_views.connect 'projects/:project_id/boards/:board_id/manage_topic', :action => 'manage_topic'
        bw_views.connect 'projects/:project_id/boards/:board_id/manage_topic_remote', :action => 'manage_topic_remote'
        bw_views.connect 'projects/:project_id/manage_wiki/:id', :action => 'manage_wiki'
        bw_views.connect 'issues_watchers_bulk', :action => 'issues_watchers_bulk'
        bw_views.connect 'watch_bulk_issues', :action => 'watch_bulk_issues'
      end
      bw_routes.with_options :conditions => {:method => :post} do |bw_views|
        bw_views.connect 'projects/:project_id/boards/:board_id/manage', :action => 'manage'
        bw_views.connect 'projects/:project_id/boards/:board_id/manage_topic', :action => 'manage_topic'
        bw_views.connect 'projects/:project_id/boards/:board_id/manage_topic_remote', :action => 'manage_topic_remote'
        bw_views.connect 'projects/:project_id/manage_wiki/:id', :action => 'manage_wiki'
        bw_views.connect 'issues_watchers_bulk', :action => 'issues_watchers_bulk'
        bw_views.connect 'watch_bulk_issues', :action => 'watch_bulk_issues'
      end
    end
  end
end
