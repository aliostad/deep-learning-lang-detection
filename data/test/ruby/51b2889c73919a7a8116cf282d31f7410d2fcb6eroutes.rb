Rails.application.routes.draw do
  match '/:scope/:scope_id/fields/manage' => 'has_fields/manage/fields#index', :as => :manage_fields, :via => :get
  match '/:scope/:scope_id/fields/manage/new' => 'has_fields/manage/fields#new', :as => :new_manage_fields, :via => :get
  match '/:scope/:scope_id/fields/manage' => 'has_fields/manage/fields#create', :as => :manage_fields, :via => :post
  match '/:scope/:scope_id/fields/manage/:id/edit' => 'has_fields/manage/fields#edit', :as => :edit_manage_field, :via => :get
  match '/:scope/:scope_id/fields/manage/:id' => 'has_fields/manage/fields#update', :as => :update_field, :via => :put
  match '/:scope/:scope_id/fields/manage/:id' => 'has_fields/manage/fields#show', :as => :manage_field, :via => :get
  match '/:scope/:scope_id/fields/manage/:id' => 'has_fields/manage/fields#destroy', :as => :destroy_manage_fields, :via => :delete
  match '/:resource/:id/fields/edit' => 'HasFields/fields#edit', :as => :edit_fields, :via => :get
  match '/:resource/:id/fields' => 'has_fields/fields#index', :as => :fields, :via => :get
  match '/:resource/:id/fields' => 'has_fields/fields#update', :as => :update_fields, :via => :put
end
