class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.has_role? :sysadmin
      can :manage, :all

    elsif user.has_role? :superadmin
      can :manage, :all
      # .. Cannot manage other superadmins or sysadmin through role queries in the views

    elsif user.has_role? :admin
      can :manage, Circle
      can :manage, CircleMembership
      can :manage, User, id: user.id
      can :read, User

    else
      can :read, Circle
      # can :manage, CircleMembership
      can :manage, User, id: user.id
      can :read, User

    end

  end

end
