class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)

    if user.role == 'admin'
      can :manage, :all
    elsif user.role == 'member'
      can :read, User # can access other users profile
      can :manage, User , :id => user.id
      can :tags, Post
      cannot :index, User # list users page
    elsif user.role == 'publisher'
      can :manage, User , :id => user.id
      can :manage, Post , :user_id => user.id
      can :manage, ContactInfo, :user_id => user.id
    else
      can :read, :all
    end
  end
end
