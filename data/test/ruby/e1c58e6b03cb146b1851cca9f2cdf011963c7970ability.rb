class Ability
  include CanCan::Ability

  def initialize(user, session)
    # Define abilities for the passed in user here. For example:

    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :user
      can :manage, User, :id => user.id
      can :manage, Folder, :user_id => user.id
      can :manage, Project, :user_id => user.id
      can :manage, Task, :user_id => user.id
      can :manage, TaskContext, :user_id => user.id
      can :manage, Tag, :user_id => user.id
    end
  end
end


