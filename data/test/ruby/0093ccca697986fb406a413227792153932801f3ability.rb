class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :manager
      can :read, :all
      can :manage, Plantask
      can :manage, Area
      can :manage, Equipment
      can :manage, Part
      can :manage, Procedure
      can :manage, WorkOrder
      can :manage, MiscWorkOrder
      can :create, Record
      can :update, EggTimer
    else
      can :read, :all
      can :update, Plantask
      can :create, Record
      can :update, WorkOrder
      can :update, MiscWorkOrder
    end
  end
end
