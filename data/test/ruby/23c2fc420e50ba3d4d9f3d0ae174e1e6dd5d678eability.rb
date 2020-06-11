class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    ## common
    can :manage, Context do | context |
      user.manager_of? context
    end

    can :manage, Permission do | permission |
      permission.context && can?(:manage, permission.context)
    end

    can [:new, :create], Permission do | permission |
      !permission.context && user.manager?
    end

    can [:search, :index], User do
      user.manager?
    end

    can :manage, :application do
      user.permissions.any?
    end

    can :manage, :permissions do
      user.manager?
    end

    ## app specific
    can :manage, Subcontext do | subcontext |
      user.manager_of? subcontext.context
    end

    can :manage, Subcontext do | subcontext |
      user.manager_of? subcontext
    end

    can :manage, :all if user.manager_of?(Context.first)
  end
end
