class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    ## GUEST ##
    can :read, :all

    ## ANY USER ##
    unless user.new_record?
      can :manage, user
    end

    ## DISPATCH USERS ##
    if user.has_role? :dispatcher

      cannot :manage, Airport
      can :create, Airport

      cannot :manage, NonFuelCharge
      can :crud, NonFuelCharge

      cannot :manage, Plane

      cannot :manage, Receipt
      can :crud, Receipt

      cannot :manage, Report

      cannot :manage, User
      can :crud, user

    end

    ## ADMIN USERS ##
    if user.has_role? :admin
      can :manage, :all
    end
  end
end
