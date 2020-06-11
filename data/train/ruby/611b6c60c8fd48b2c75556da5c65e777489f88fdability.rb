class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    # if a member, they can manage their own posts 
    # (or create new ones)
    if user.role? :member
      can :manage, Bookmark, :user_id => user.id
      can :manage, Like, :user_id => user.id
      can :manage, Topic, :user_id => user.id
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    can :read, :all
  end
end
