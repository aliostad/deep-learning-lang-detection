class FebeeWorkspace < ActiveRecord::Base
  unloadable

  belongs_to :febee_project_configuration

  # Returns updated GitRepository object
  def git_repository
    @git_repository ||= GitRepository.new(self)
    if @git_repository.repository_initialized?
      PerRequestCache.fetch(:update_workspace) do
        update_interval = febee_project_configuration.update_interval
        if !update_interval || !last_git_fetch ||
          last_git_fetch < update_interval.seconds.ago
          @git_repository.fetch_from_server
        end
      end
    end
    @git_repository
  end

  def path=(new_path)
    @git_repository = nil
    write_attribute(:path, new_path)
  end
end
