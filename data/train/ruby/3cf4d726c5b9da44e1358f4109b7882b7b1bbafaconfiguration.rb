module Oauth2Server
  class Configuration
    attr_writer :token_length
    attr_accessor :realm

    def token_length
      @token_length || 32
    end

    def registered_client_repositories
      @_registered_client_repositories ||= []
    end

    def register_client_repository(client_repository)
      registered_client_repositories << client_repository
    end

    def registered_token_repositories
      @_registered_token_repositories ||= []
    end

    def register_token_repository(token_repository)
      registered_token_repositories << token_repository
    end

    def registered_authorization_grant_repositories
      @_registered_authorization_grant_repositories ||= []
    end

    def register_authorization_grant_repository(authorization_grant_repository)
      registered_authorization_grant_repositories << authorization_grant_repository
    end

    def registered_resource_owner_repositories
      @_registered_resource_owner_repositories ||= []
    end

    def register_resource_owner_repository(resource_owner_repository)
      registered_resource_owner_repositories << resource_owner_repository
    end
  end
end
