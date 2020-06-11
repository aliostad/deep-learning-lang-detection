ProjectGogi::Application.routes.draw do
    root :to => "main_page#home"

    authenticated :user do
        match '/home', to:'main_page#home', via: 'get'
    end

    devise_for :users
    match '/home',                         to: 'main_page#home',               via: 'get'
    match '/manage_group',                 to: 'manage_group#manage',          via: 'GET'
    match '/manage_group/add_member',      to: 'manage_group#add_member',      via: 'POST'
    match '/manage_group/update_member',   to: 'manage_group#update_member',   via: 'PATCH'
    match '/manage_group/update_profile',  to: 'manage_group#update_profile',  via: 'PATCH'
    match '/manage_group/get_all_members', to: 'manage_group#get_all_members', via: 'GET',  defaults: { format: 'xml' }

end
