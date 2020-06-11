module RepositoriesHelper

  include ActsAsTaggableOn::TagsHelper

  def repository_link(repository)
    raw (link_to repository.name, user_repository_path(repository.username, repository.name))
  end

  def repository_link_full(repository)
    raw user_link(repository.user) + "/" + repository_link(repository)
  end

  def repository_watchers_count_link(repository)
    raw link_to repository.watchers_count,
                user_repository_watchers_path(repository.username, repository.name),
                :class => "btn large small",
                :rel => "twipsy",
                :data => {:original_title => t("repositories.helper.watchers"),
                          :placement => :below,
                          "repository_watchers_count_#{repository.id}" => true}
  end

  def repository_forks_count_link(repository)
    raw link_to repository.forks_count,
                user_repository_forks_path(repository.username, repository.name),
                :class => "btn large small",
                :rel => "twipsy",
                :data => {:original_title => t("repositories.helper.forks"),
                          :placement => :below,
                          "repository_forks_count_#{repository.id}" => true}
  end

  def repository_fork_link(repository)
    if repository.forked_by_user?(current_user)
      raw link_to t("repositories.helper.forked"),
                  user_repository_path(current_user.username, repository.forked_by_user(current_user).name),
                  :class => "btn small",
                  :rel => "twipsy",
                  :data => {:original_title => t("repositories.helper.forked_info"),
                            :placement => :below}
    else
      raw link_to t("repositories.helper.fork"),
                  user_repository_fork_path(repository.username, repository.name),
                  :method => :put,
                  :class => "btn small primary"
    end
  end

  def repository_reverse_watch_link(repository)
    raw link_to (current_user.watching_repository?(repository) ? t("repositories.helper.unwatch") : t("repositories.helper.watch")),
                user_repository_reverse_watch_path(repository.username, repository.name),
                :method => :put,
                :remote => true,
                :data => { "repository_reverse_watch_#{repository.id}" => true,
                            :buttons => true,
                            :loading_text => t(:requesting),
                            :timeout_text => t(:request_timeout),
                            :server_error_text => t(:request_server_error),
                            :alerts_containers_div => "alerts",
                            :watch_complete_text => t("repositories.helper.unwatch"),
                            :unwatch_complete_text => t("repositories.helper.watch")},
                :class => "btn small primary"
  end
  
end
