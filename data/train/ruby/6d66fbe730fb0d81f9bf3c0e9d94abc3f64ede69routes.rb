Caravana::Application.routes.draw do
  root :to => "admin/dashboard#index"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  post "api/send_report"
  post "api/insert_test_drive_queue"
  post "api/no_show"
  post "api/receive_premiation"
  post "api/create_user"

  get "api/events"
  get 'api/pending_users'

  get "api/list_test_drive"
  get "api/can_receive_premiation"
  get "api/check_cpf"
  get "api/check_email"
  get "api/list_premiation"
  get "api/list_midia_reports"

  post "api/show_in_premiation"
  post "api/show_in_midia_survey"
  post "api/check_no_show_premiation"
  post "api/no_show_midia_survey"
end
