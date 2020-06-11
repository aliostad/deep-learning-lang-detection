Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      scope '/lists' do
        get '/' => 'lists_api#index'
        post '/' => 'lists_api#create'
        scope '/:name' do
          get '/' => 'lists_api#show'
          put '/' => 'lists_api#update'
          scope '/todos' do
            get '/' => 'api_todos#index'
            post '/' => 'api_todos#create'
            scope '/:todo_name' do
              get '/' => 'api_todos#show'
              put '/' => 'api_todos#update'
            end
          end
        end
      end
    end
  end
end

