class Ability
  include CanCan::Ability
  #user ||= User.new # guest user (not logged in)
  def initialize(user)
    if user.nil?
      can :read, Post
    elsif user.normal?
      can :read, Post
      can :manage, User, :id => user.id
    elsif user.high?
      can :read, Post
      can :manage, Post, :user_id => user.id
      can :create, Comment
      can :manage, User, :id => user.id
      can :create, Note
      can :read, Activity
      can :create, Activity
      can :manage, Activity, :id => user.id
      can :read, Cash
      can :create, Cash
      can :mamage, Cash, :id => user.id
    elsif user.vip?
      can :read, Post
      can :manage, Post, :user_id => user.id
      can :create, Comment
      can :manage, User, :id => user.id
      can :create, Note
      can :read, Activity
      can :create, Activity
      can :manage, Activity, :id => user.id
      can :read, Cash
      can :create, Cash
      can :mamage, Cash, :id => user.id
    elsif user.admin?
      can :manage, :all
      #can :manage, Admin
    else
      can :read, Post
    end
  end
end

