# frozen_string_literal: true
module LogSubscribers
  module GitControllerRuntime
    extend ActiveSupport::Concern

    protected

    attr_internal :git_repository_loader_before
    attr_internal :git_repository_loader_during

    attr_internal :git_repository_before
    attr_internal :git_repository_during

    def cleanup_view_runtime
      self.git_repository_loader_before = GitRepositoryLoaderSubscriber.reset_runtime
      self.git_repository_before = GitRepositorySubscriber.reset_runtime

      runtime = super

      self.git_repository_loader_during = GitRepositoryLoaderSubscriber.reset_runtime
      self.git_repository_during = GitRepositorySubscriber.reset_runtime

      runtime - git_repository_loader_during - git_repository_during
    end

    def append_info_to_payload(payload)
      super
      payload[:git_repository_loader] = repository_loader_runtime
      payload[:git_repository] = repository_runtime
    end

    def repository_runtime
      (git_repository_before || 0) + (git_repository_during || 0) + GitRepositorySubscriber.reset_runtime
    end

    def repository_loader_runtime
      (git_repository_loader_before || 0) + (git_repository_loader_during || 0) +
        GitRepositoryLoaderSubscriber.reset_runtime
    end

    module ClassMethods
      def log_process_action(payload)
        messages = super
        git_repository_loader = payload[:git_repository_loader]
        messages << format('Git Load: %.1fms', git_repository_loader) if git_repository_loader

        git_repository = payload[:git_repository]
        messages << format('Git Query: %.1fms', git_repository) if git_repository
        messages
      end
    end
  end
end
