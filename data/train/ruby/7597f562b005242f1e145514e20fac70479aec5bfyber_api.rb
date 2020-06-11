Jeckle.configure do |config|
  config.register :fyber_api do |api|
    api.base_uri     = Fyber::APISettings.base_uri
    api.namespaces   = {
      prefix:  Fyber::APISettings.prefix,
      version: Fyber::APISettings.version
    }
    api.headers      = { 'Content-Type' => 'application/json' }
    api.logger       = Rails.logger

    api.open_timeout = Fyber::APISettings.open_timeout
    api.read_timeout = Fyber::APISettings.read_timeout

    api.middlewares do
      request :json
      response :json
    end
  end
end