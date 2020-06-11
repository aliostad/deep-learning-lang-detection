Jeckle.configure do |config|
  config.register :my_super_api do |api|
    api.base_uri = 'http://my-super-api.com.br'
    api.headers = { 'Content-Type' => 'application/json' }
    api.logger = Logger.new(STDOUT)
    api.basic_auth = { username: 'steven_seagal', password: 'youAlwaysLose' }
    api.namespaces = { prefix: 'api', version: 'v1' }
    api.params = { hello: 'world' }
    api.open_timeout = 2
    api.read_timeout = 5

    api.middlewares do
      request :json
      response :json
      response :raise_error
    end
  end

  config.register :another_api do |api|
    api.base_uri = 'http://another-api.com.br'
    api.headers = { 'Content-Type' => 'application/json' }
    api.logger = Logger.new(STDOUT)
    api.basic_auth = { username: 'heisenberg', password: 'metaAfetaAMina' }
    api.namespaces = { prefix: 'api', version: 'v5' }
    api.params = { hi: 'there' }

    api.middlewares do
      request :json
      response :json
      response :raise_error
    end
  end
end
