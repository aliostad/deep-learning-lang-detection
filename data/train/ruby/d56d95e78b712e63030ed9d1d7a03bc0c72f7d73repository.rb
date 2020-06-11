require "anypresence_generator/repository/archive"
require "anypresence_generator/repository/git"

module AnypresenceGenerator
  module Repository

    attr_accessor :repository, :git_user, :git_email

    def init_or_clone
      if new_generation?
        log "Creating project directories and initializing source control"
        repository.init
      else
        log "Retrieving project from source control"
        repository.clone(recursive: true)
      end
    end

    def commit_to_repository(message: "Generating version #{api_version.number}.")
      log "Committing to local source control: #{message}"
      repository.commit(commit_message: message)
    end

    def push_to_repository
      log "Pushing to remote source control."
      repository.push
    end

    def setup_repository
      log 'Setting up repository.'
      if payload.repository.type.eql?("ApplicationDefinition::Repository::Archive".freeze)
        self.repository = ::AnypresenceGenerator::Repository::Archive.new(workhorse: self, repository_payload: payload.repository, directory: project_directory, user_name: git_user, user_email: git_email, mock: mock, max_network_retry: max_network_retry)
      elsif payload.repository.type.eql?("ApplicationDefinition::Repository::Github".freeze)
        self.repository = ::AnypresenceGenerator::Repository::Git.new(workhorse: self, repository_payload: payload.repository, directory: project_directory, user_name: git_user, user_email: git_email, mock: mock, max_network_retry: max_network_retry)
      else
        raise WorkableError.new("Unsupported repository type: #{payload.repository.type}")
      end
    end

    def new_generation?
      !repository.pushed
    end

  end
end