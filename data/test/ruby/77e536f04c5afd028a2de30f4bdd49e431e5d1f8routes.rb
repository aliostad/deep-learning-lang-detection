                  Prefix Verb     URI Pattern                                      Controller#Action
        new_user_session GET      /users/sign_in(.:format)                         devise/sessions#new
            user_session POST     /users/sign_in(.:format)                         devise/sessions#create
    destroy_user_session DELETE   /users/sign_out(.:format)                        devise/sessions#destroy
 user_omniauth_authorize GET|POST /users/auth/:provider(.:format)                  devise/omniauth_callbacks#passthru {:provider=>/(?!)/}
  user_omniauth_callback GET|POST /users/auth/:action/callback(.:format)           devise/omniauth_callbacks#:action
           user_password POST     /users/password(.:format)                        devise/passwords#create
       new_user_password GET      /users/password/new(.:format)                    devise/passwords#new
      edit_user_password GET      /users/password/edit(.:format)                   devise/passwords#edit
                         PATCH    /users/password(.:format)                        devise/passwords#update
                         PUT      /users/password(.:format)                        devise/passwords#update
cancel_user_registration GET      /users/cancel(.:format)                          registrations#cancel
       user_registration POST     /users(.:format)                                 registrations#create
   new_user_registration GET      /users/sign_up(.:format)                         registrations#new
  edit_user_registration GET      /users/edit(.:format)                            registrations#edit
                         PATCH    /users(.:format)                                 registrations#update
                         PUT      /users(.:format)                                 registrations#update
                         DELETE   /users(.:format)                                 registrations#destroy
       api_herd_weeklies GET      /api/herd_weeklies(.:format)                     api/herd_weeklies#index
                         POST     /api/herd_weeklies(.:format)                     api/herd_weeklies#create
     new_api_herd_weekly GET      /api/herd_weeklies/new(.:format)                 api/herd_weeklies#new
    edit_api_herd_weekly GET      /api/herd_weeklies/:id/edit(.:format)            api/herd_weeklies#edit
         api_herd_weekly GET      /api/herd_weeklies/:id(.:format)                 api/herd_weeklies#show
                         PATCH    /api/herd_weeklies/:id(.:format)                 api/herd_weeklies#update
                         PUT      /api/herd_weeklies/:id(.:format)                 api/herd_weeklies#update
                         DELETE   /api/herd_weeklies/:id(.:format)                 api/herd_weeklies#destroy
        api_weekly_tasks POST     /api/weekly_tasks(.:format)                      api/weekly_tasks#create
         api_weekly_task PATCH    /api/weekly_tasks/:id(.:format)                  api/weekly_tasks#update
                         PUT      /api/weekly_tasks/:id(.:format)                  api/weekly_tasks#update
                         DELETE   /api/weekly_tasks/:id(.:format)                  api/weekly_tasks#destroy
               api_goals GET      /api/goals(.:format)                             api/goals#index
                         POST     /api/goals(.:format)                             api/goals#create
            new_api_goal GET      /api/goals/new(.:format)                         api/goals#new
           edit_api_goal GET      /api/goals/:id/edit(.:format)                    api/goals#edit
                api_goal GET      /api/goals/:id(.:format)                         api/goals#show
                         PATCH    /api/goals/:id(.:format)                         api/goals#update
                         PUT      /api/goals/:id(.:format)                         api/goals#update
                         DELETE   /api/goals/:id(.:format)                         api/goals#destroy
    api_section_comments GET      /api/sections/:section_id/comments(.:format)     api/comments#index
                         POST     /api/sections/:section_id/comments(.:format)     api/comments#create
     api_section_comment DELETE   /api/sections/:section_id/comments/:id(.:format) api/comments#destroy
             api_section PATCH    /api/sections/:id(.:format)                      api/sections#update
                         PUT      /api/sections/:id(.:format)                      api/sections#update
         api_focus_areas GET      /api/focus_areas(.:format)                       api/focus_areas#index
                         POST     /api/focus_areas(.:format)                       api/focus_areas#create
          api_focus_area PATCH    /api/focus_areas/:id(.:format)                   api/focus_areas#update
                         PUT      /api/focus_areas/:id(.:format)                   api/focus_areas#update
                         DELETE   /api/focus_areas/:id(.:format)                   api/focus_areas#destroy
     profile_api_uploads POST     /api/uploads/profile(.:format)                   api/uploads#profile
  login_todoist_api_user POST     /api/users/:id/login_todoist(.:format)           api/users#login_todoist
      feedback_api_users POST     /api/users/feedback(.:format)                    api/users#feedback
               api_users GET      /api/users(.:format)                             api/users#index
         api_user_weekly PATCH    /api/user_weeklies/:id(.:format)                 api/user_weeklies#update
                         PUT      /api/user_weeklies/:id(.:format)                 api/user_weeklies#update
          api_activities GET      /api/activities(.:format)                        api/activities#index
                    join GET      /join(.:format)                                  redirect(301, /users/sign_up)
                         GET      /                                                herds#show
                         GET      /*a(.:format)                                    herds#show
                new_herd GET      /new(.:format)                                   herds#new
                   herds POST     /herds(.:format)                                 herds#create
                    root GET      /                                                onboarding#index
