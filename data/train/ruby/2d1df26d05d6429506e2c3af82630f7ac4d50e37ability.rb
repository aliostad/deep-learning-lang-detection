class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, User, :organization_id => user.organization_id
      can :manage, Physician, :organization_id => user.organization_id
      can :manage, Patient, :organization_id => user.organization_id
      can :manage, Appointment, :organization_id => user.organization_id
      can :manage, Dashboard, :organization_id => user.organization_id
      # can :manage, Account
      # can :manage, User, :account_id => user.account_id
      # can :manage, Period, :account_id => user.account_id
      # can :manage, Review, :account_id => user.account_id
      # can :manage, Goal, :user_id => user.id
      # can :manage, Progress, :user_id => user.id
      can :manage, Dashboard
    end

    if user.type == "Physician"
      can :manage, User, :organization_id => user.organization_id
      can :manage, Physician, :organization_id => user.organization_id
      can :manage, Patient, :organization_id => user.organization_id
      can :manage, Appointment, :organization_id => user.organization_id
      can :manage, Dashboard, :organization_id => user.organization_id
      # can :manage, Account
      # can :manage, User, :account_id => user.account_id
      # can :manage, Period, :account_id => user.account_id
      # can :manage, Review, :account_id => user.account_id
      # can :manage, Goal, :user_id => user.id
      # can :manage, Progress, :user_id => user.id
      can :manage, Dashboard
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
