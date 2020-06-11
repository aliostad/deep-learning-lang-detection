Pbw::Engine.routes.draw do
	devise_for :users, {
	    class_name: 'Pbw::User',
	    controllers: { registrations: 'pbw/registrations', :sessions => 'pbw/sessions', :passwords => 'pbw/passwords'},
	    module: :devise
 	}
 	%W{areas commands items tokens}.each do |controller|
 		get "#{controller}/:_type" => "#{controller}\#index"
 		get "#{controller}/:_type/:id" => "#{controller}\#show"
 		post "#{controller}/:_type" => "#{controller}\#create"
 		delete "#{controller}/:_type/:id" => "#{controller}\#destroy"
 		put "#{controller}/:_type/:id" => "#{controller}\#update"
 	end
end
