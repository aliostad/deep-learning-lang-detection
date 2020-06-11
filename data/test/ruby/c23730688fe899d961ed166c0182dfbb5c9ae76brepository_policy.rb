class RepositoryPolicy

  attr_reader :user, :repository, :authorization

  def self.allowed?(user, repository, action, *args)
    action = "#{action.to_s.gsub('-', '_')}?"
    new(user, repository).public_send(action, *args)
  end

  def initialize(user, repository, authorization = Gitorious::Authorization::DatabaseAuthorization.new)
    @user = user
    @repository = repository
    @authorization = authorization
  end

  def read?
    return false if !Gitorious.public? && !user
    authorization.can_read_repository?(user, repository)
  end

  def push?
    authorization.can_push?(user, repository)
  end

end
