Itinerary::Engine.routes.draw do

	#root to: "controller_name#index"
	#scope 'admin' do

	#end

	scope 'api' do
		scope '1' do
			resources :todos, controller: 'api/v1/todos'
			#/api/1/controller_name
			#resources :controller_name, controller: 'api/v1/controller_name'
			#resources :controller_name2, controller: 'api/v1/controller_name2' do
				#collection do
					#/api/1/controller_name2/action
					#post 'action', to: "api/v1/controller_name2#action"
				#end
			#end
		end
	end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
	  	
end
