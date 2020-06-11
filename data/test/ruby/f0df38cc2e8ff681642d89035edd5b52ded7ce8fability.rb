class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Appointment, :user_id => user.id
    can :manage, Baby, :user_id => user.id
    can :manage, Food, :user_id => user.id
    can :manage, Journal, :user_id => user.id
    can :manage, Milestone, :user_id => user.id
    can :manage, Photo, :user_id => user.id
    can :manage, Weight, :user_id => user.id
    can :read, Forum
    can :read, Comment
    can :destroy, Comment, :user_id => user.id
    can :create, Comment, :user_id => user.id
    can :update, Comment, :user_id => user.id
    can :manage, Wish, :user_id => user.id
    can :manage, WishItem, :user_id => user.id

  end
end
