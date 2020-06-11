RailsWanguo::Application.routes.draw do

  match "phonesign/generate"

  match "phonesign/validate"

  resources :dlogs


  get "epmenus/index"

  get "epmenus/show"

  # resources :passwords, only: [:create]

  resources :schools


  resources :books do 
    member do
      match 'move_up'
      match 'move_down'
    end
  end


  resources :import_errors

  get 'entrance/download'

  get 'entrance/download_link'

  get "captchas/generate"
  
  get "captchas/valid"

  get "captchas/expired"

  get "captchas/unused"

  # get 'users/index'

  # get 'users/:id/view'

  # resource :session, controller: 'sessions'

  resources :people,:only=>[:index,:show,:destroy,:edit,:update] do
    member do
      get 'collected_laws/(:law_id)',:action=>'collected_laws'
    end
  end

  resources :epmenus,:only=>[] do 
    resources :questions,:only=>[:index]
  end

  resources :captchas


  resources :heartbeats

  match 'api/moni_menu'
  
  match 'api/cities'

  match 'api/forget_password'

  post 'api/zhentis'

  post 'api/zhenti'

  post 'api/books'

  post 'api/schools'

  post 'api/user_validity'
  
  post 'api/assign_captcha'

  post 'api/login'

  post 'api/edit_profile'

  post 'api/logout'

  post 'api/signup'

  post 'api/mix'

  post 'api/istudy_sub_epmenus_summaries'

  post 'api/istudy_epmenu_summary'

  post 'api/istudy_epmenus_summaries'

  post 'api/istudy_xueba'

  post 'api/istudy_complex'

  post 'api/istudy_complex_rank'

  post 'api/istudy_evaluate'

  post 'api/history'

  post 'api/history_by_epmenu'

  post 'api/history_by_epmenu_eps'    

  post 'api/history_total_avg_by_epmenu'

  post 'api/history_total_avg_by_epmenu_eps'
# =======
#   # 每个部门法的累计学习时间
#   post 'api/istudy_epmenu_time'
#   # 每个部门法的真题训练情况（总题数，答对，答错）
#   post 'api/istudy_epmenu_questions_summary'
#   # 每个部门法的整体学习进度（计算方法详见istudy中的表格）
#   post 'api/istudy_epmenu_schedule'
#   # 每个部门法的真题训练情况（总题数，答对，答错）
#   post 'api/answer_status_by_epmenu'
#   # 每个部门法对应知识点的真题训练情况（总题数，答对，答错）
#   post 'api/istudy_epmenu_questions_summary_by_eps'  
#   # 学霸指数（根据用户平均每天使用时间来定）
#   get 'api/istudy_index'
#   # 整体的真题训练情况（总题数，答对，答错）
#   post 'api/istudy_questions_summary'
# >>>>>>> 11ce8f762cd17ac07fac6f32dd8751ce9dd0e9ba
  
  get 'imports/import_all'
  
  get "entrance/callback"

  post 'api/search_laws'

  post 'api/search_freelaws'  
  
  post 'api/epmenus'

  post 'api/mistake_epmenus'

  post 'api/mistake_eps'

  post 'api/heartbeat_start'

  post 'api/heartbeat_beat'

  post 'api/heartbeat_stop'

  match 'api/play_audio(/:id)'=>'api#play_audio',:as=>'api_play_audio'

  match 'api/open_blank(/:id)'=>'api#open_blank',:as=>'api_open_blank'

  match 'api/collect_law(/:id)'=>'api#collect_law',:as=>'api_collect_law'

  match 'api/uncollect_law(/:id)'=>'api#uncollect_law',:as=>'api_collect_law'

  match 'api/collect_question(/:id)'=>'api#collect_question',:as=>'api_collect_question'

  match 'api/collect_freelaw(/:id)'=>'api#collect_freelaw',:as=>'api_collect_freelaw'

  match 'api/uncollect_question(/:id)'=>'api#uncollect_question',:as=>'api_uncollect_question'

  match 'api/uncollect_freelaw(/:id)'=>'api#uncollect_freelaw',:as=>'api_uncollect_freelaw'

  match "api/collected_laws(/:id)"=>"api#collected_laws",:as=>"api_collected_laws",:defaults=>{:id=>nil}

  match "api/collected_freelaws(/:id)"=>"api#collected_freelaws",:as=>"api_collected_freelaws",:defaults=>{:id=>nil}

  match 'api/collected_epmenus'=>'api#collected_epmenus',:as=>'api_collected_epmenus'

  match 'api/collected_eps_by_epmenu/:id'=>'api#collected_eps_by_epmenu',:as=>'api_collected_eps_by_epmenu'

  match 'api/collected_questions_by_ep/:id'=>'api#collected_questions_by_ep',:as=>'api_collected_questions_by_ep'

  match 'api/collected_questions_by_epmenu/:id'=>'api#collected_questions_by_epmenu',:as=>'api_collected_questions_by_epmenu'

  match 'api/collected_eps'=>'api#collected_eps',:as=>'api_collected_eps'

  match 'api/epmenus(/:epmenu_id)'=>'api#epmenus',:as=>'api_epmenus'

  match 'api/answer_questions'

  match 'api/answer_question/:question_id/:answer'=>'api#answer_question',:as=>'api_answer_question'

  match 'api/mistake_questions_by_epmenu/:epmenu_id'=>'api#mistake_questions_by_epmenu',:as=>'api_mistake_questions_by_epmenu'

  match 'api/mistake_questions_by_ep/:exampoint_id'=>'api#mistake_questions_by_ep',:as=>'api_mistake_questions_by_ep'

  match 'api/mistake_eps_by_epmenu/:epmenu_id'=>'api#mistake_eps_by_epmenu',:as=>'api_mistake_eps_by_epmenu'

  match "api/epmenu_questions/:id(/:limit)"=>"api#epmenu_questions",:as=>"api_epmenu_questions",:defaults=>{:limit=>15}

  match "api/rapid_questions/:volumn(/:limit)"=>"api#rapid_questions",:as=>"api_rapid_questions",:defaults=>{:limit=>15}

  match "api/ep_questions/:id"=>"api#ep_questions",:as=>"api_ep_questions"

  match "api/law_eps/:id"=>"api#law_eps",:as=>"api_law_eps"

  match "api/law_questions/:id"=>"api#law_questions",:as=>"api_law_questions"

  match "api/law_blanks/:id"=>"api#law_blanks",:as=>"api_law_blanks"
  

  match "api/laws(/:id)"=>"api#laws",:as=>"api_laws",:defaults=>{:id=>nil}

  match "api/freelaws(/:id)"=>"api#freelaws",:as=>"api_freelaws",:defaults=>{:id=>nil}

  resources :questions

  resources :imports do
    collection do
      match 'explain'
    end

    member do
      match 'import'
    end
  end


  resources :annexes


  resources :exampoints


  resources :laws do
    member do
      match 'move_up'
      match 'move_down'
    end
  end


  resources :freelaws do
    member do
      match 'move_up'
      match 'move_down'
    end
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       post 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'entrance#welcome'


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
