class Ability
  include CanCan::Ability

  def initialize(user, namespace = nil)
    user ||= User.new


    case namespace
    when 'admin' then admin_abilities(user)
    when 'api'   then api_abilities(user)
    else              default_abilities(user)
    end
  end

  def admin_abilities(user)
    if user.feed_admin?
      can :manage, Feed
      can :manage, Sensor
      can :manage, WebHook
    end

    if user.job_admin?
      can :manage, Queue
    end

    if user.user_admin?
      can :manage, User
      can :manage, Member
    end

    if user.site_admin?
      can :manage, User
      can :manage, Member
      can :manage, Feed
      can :manage, Sensor
      can :manage, WebHook
      can :manage, Queue
      can :manage, ApiKey
    end
  end

  def default_abilities(user)
    can :read, Feed
    can :read, Sensor
    can :read, Movie
  end

  def api_abilities(token)
    can :read, Feed
    can :create, Import
  end
end
