class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Recording
    can :manage, Recording, :userID => user.id

    can :read, Call, :user_id => user.id

    can :read, List, :user_id => user.id
    can :manage, List, :user_id => user.id

    can :read, Contact, :user_id => user.id
    can :manage, Contact, :user_id => user.id

    can :manage, Import, :user_id => user.id

    can :read, TextMessage, :user_id => user.id
    can :manage, TextMessage, :user_id => user.id

    can :manage, Dnc, :account => user.id
  end
end
