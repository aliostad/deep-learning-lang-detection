class FollowGithubRepositoryUsecase

  attr_reader :user, :repository, :repository_name, :github_adapter, :db

  def initialize(user, repository_name, github_adapter = Github::Adapter, db = Db.new)
    @user            = user
    @repository_name = repository_name
    @github_adapter  = github_adapter.new(user)
    @db              = db
  end

  def execute
    hook = github_adapter.add_web_hook(repository_name, hook_url)
    db.create_or_update_repository(user, repository_name, hook.id)
  end

  def hook_url
    UrlAdapter.github_hook_url
  end

end
