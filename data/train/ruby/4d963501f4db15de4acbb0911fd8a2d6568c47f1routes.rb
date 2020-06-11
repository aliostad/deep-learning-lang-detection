FrayAcademicSystem::Application.routes.draw do



  #get "users/sign_in", to: "welcome#index"

  devise_for :users do

    get "/login" => "devise/sessions#new"
    get "users/sign_in" => "welcome#index"
    get "/logout" => "devise/sessions#destroy"

  end

  get "groups/report", to: "groups#report"
  get "groups/assign_student", to: "groups#assign_student"
  get "groups/manage", to: "groups#manage"

  get "teachers/report", to: "teachers#report"
  get "teachers/manage", to: "teachers#manage"

  get "students/report", to: "students#report"
  get "students/manage", to: "students#manage"

  get "lectures/manage", to: "lectures#manage"
  get "lectures/report", to: "lectures#report"

  get "subjects/report", to: "subjects#report"
  get "subjects/manage", to: "subjects#manage"
  get "institutions/manage", to: "institutions#manage"
  get "stages/manage", to: "stages#manage"
  get "periods/manage", to: "periods#manage"
  #get "lectures/assign_students/:id/:student_id", to: "lectures#assign_students"
  get "schedules/manage", to: "schedules#manage"

  get "grade_weights/assign_weight/:lecture_id", to: "grade_weights#assign_weight"

  get "/grades/overall_lecture/:lecture_id", to: "grades#overall_lecture"
  get "/grades/overall_lecture_weight/:lecture_id", to: "grades#overall_lecture_weight"
  get "grades/manage", to: "grades#manage"
  get "grades/manage/:id", to: "grades#manage"
  get "grades/manage/:id/:lecture_id", to: "grades#manage"
  get "grades/new/:student_id/:lecture_id", to: "grades#new_with_student"


  resources :lectures

  resources :records

  resources :schedules

  resources :stages

  resources :subjects

  resources :users

  resources :groups

  resources :grades

  resources :periods

  resources :institutions

  resources :teachers

  resources :students

  get "welcome/index"
  root to: "welcome#index"
end
