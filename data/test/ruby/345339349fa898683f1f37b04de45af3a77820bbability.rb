class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
    when 'admin'
      can :manage, :all
    when 'editor'
      can :manage, Event
      can :manage, Lookbook
      can :manage, News
      can :manage, Area
      can :manage, User.readers
      can :read, User
      can :update, User do |user_to_update|
        user_to_update.id == user.id
      end
    when 'reader'
      can :vote, Lookbook
      can :create, Event
      can :manage, Event do |event_to_update|
        event_to_update.user_id == user.id
      end
    when 'banned'
      cannot :manage, :all
    end if user
  end
end
