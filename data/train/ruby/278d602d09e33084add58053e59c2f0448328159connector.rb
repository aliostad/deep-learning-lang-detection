module Repositories
  class Connector

    attr_reader :repository

    def initialize(user)
      @user = user
      @repository = nil
    end

    def connect(repository)
      @repository = repository
      connector = connector_for(@repository)
      connector.connect(@repository)
    end

    def disconnect(repository)
      @repository = repository
      connector = connector_for(@repository)
      connector.disconnect(@repository)
    end

    private

    def connector_for(repository)
      repo_type = repository.type
      connector_klass = "Repositories::#{repo_type.classify}Connector".safe_constantize
      connector_klass ? connector_klass.new(@user) : nil
    end

  end
end
