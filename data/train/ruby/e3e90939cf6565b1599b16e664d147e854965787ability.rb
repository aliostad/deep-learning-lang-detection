class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is? :admin
      can :manage, :all
    elsif user.is? :regular
      can :manage, Event, user_id: user.id
      can :manage, EventInstance, event: { user_id: user.id }
      can :manage, Attachment, event: { user_id: user.id }
      can :show, Attachment
      can :manage, ForumThread, event: { user_id: user.id }
      can :manage, ForumThread, user_id: user.id
      can :manage, Comment, forum_thread: { event: { user_id: user.id } }
      can :manage, Comment, forum_thread: { user_id: user.id }
      can :manage, Comment, user_id: user.id
    end
  end
end
