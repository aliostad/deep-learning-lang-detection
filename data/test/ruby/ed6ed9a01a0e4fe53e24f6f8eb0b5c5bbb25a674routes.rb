ActionController::Routing::Routes.draw do |map|
  
  map.connect 'manage/', :controller => 'manage/mng', :action => 'index'
  
  map.download_manage_mng_apache_log 'manage/mng_apache_logs/download/:filename', 
                                     :controller => 'manage/mng_apache_logs',
                                     :requirements => {  :filename => /.*/ }
                                                                         
  map.year_manage_mixi_active_history 'manage/mixi_active_histories/:year', 
                                      :controller => 'manage/mixi_active_histories', :action => 'index',
                                      :requirements => { :year => /\d{4}/ }
  
  map.year_month_manage_mixi_active_histories 'manage/mixi_active_histories/month/:year', 
                                              :controller => 'manage/mixi_active_histories', :action => 'month',
                                              :requirements => { :year => /\d{4}/ }
                                                                                                                                                                                     
  map.namespace :manage do |manage|
    manage.resources :base_active_histories, :collection => { :active_history_graph => :get }
    
    manage.resources :base_mail_templates, :new => { :create_confirm => :post },
                                          :member => [ :update_confirm, :destroy_confirm, :active_confirm, :active, 
                                                        :send_test_confirm, :send_test]

    manage.resources :base_mail_template_kinds
    manage.resources :base_plugins, :collection => { :news => :get }
    manage.resources :base_mobiles, :collection => { :search => :any,
                                                     :all_update_histories => :get, :all_update_confirm => :post, :all_update => :post }
    manage.resources :base_carriers,  :member => [ :available_confirm, :available, :unavailable_confirm, :unavailable ]
    manage.resources :base_devices,   :member => [ :available_confirm, :available, :unavailable_confirm, :unavailable ] 

    manage.resources :mng_user_action_histories
    manage.resources :mng_user_action_history_archives, :member => [ :download ]

    manage.resources :mng_system, :collection => { :check => :get, :mail => :get, :database => :get, :cache => :get }

    manage.resources :mng_apache_logs

    manage.resources :mixi_active_histories, :collection => { :year => :get, :month => :get }
    manage.resources :mixi_users

    manage.resources :mixi_inflow_masters, :new => { :create_confirm => :post }, :member => [ :update_confirm, :destroy_confirm]
    manage.resources :mixi_inflow_summaries, :collection => { :search => :any }
    
    manage.resources :mixi_app_invite_summaries, :collection => { :search => :any }
  end
   
end