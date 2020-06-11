People::Engine.routes.draw do

	root to: "users#index"

	

	scope 'api' do
		scope '1' do
	  	resources :users, controller: 'api/v1/users' do
	  		
				collection do
					# /api/1/users/register
					post 'register', to: "api/v1/users#register"
					# /api/1/users/login
					post 'login', to: "api/v1/users#login"
					# /api/1/users/logout
					post 'logout', to: "api/v1/users#logout"
					# /api/1/users/logout
					post 'authenticate/:id', to: "api/v1/users#authenticate"
					# /api/1/users/login_status
					get 'login_status', to: "api/v1/users#login_status"
				end
				
	  	end
		end
	end

end
