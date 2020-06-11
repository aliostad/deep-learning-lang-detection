# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match "/manage_usergroups/:id/update", :to=>"manage_usergroups#update" , :via => [:post,:get]

match "/manage_usergroups/index", :to=>"manage_usergroups#index" , :via => [:post,:get]

match "/manage_usergroups/:id/edit", :to=>"manage_usergroups#edit" , :via => [:post,:get]

match "/manage_usergroups/:id/autocomplete_for_user", :to=>"manage_usergroups#autocomplete_for_user" , :via => [:post,:get]

match "/manage_usergroups/:id/add_users", :to=>"manage_usergroups#add_users" , :via => [:post]

match "/manage_usergroups/:id/delete_user/:user_id", :to=>"manage_usergroups#delete_user" , :via => [:delete]



