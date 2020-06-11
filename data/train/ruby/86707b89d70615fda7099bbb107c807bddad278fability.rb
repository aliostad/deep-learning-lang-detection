class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.administrator?
      can :manage, Order
      can :manage, Task
      can :manage, UserSpool
      can :manage, Spool
      can :manage, History
      can :manage, Manufacturer
      can :manage, Metall
      can :manage, Ral
      can :manage, ControlWeight
      can :manage, Depth
      can :manage, User
      can :manage, Step
      can :manage, Machine
      can :manage, Scale
      can :manage, Printer
      can :manage, Cell
      can :manage, Product
      can :manage, :report
      can :manage, :integrator
    end

    if user.manager?
      can :manage, Order
      can :manage, Task
      can :read, Spool
      can :manage, UserSpool
      can :read, Machine
      can :read, Scale
      can :read, Printer
      can :manage, :report
      can :manage, :integrator
    end

    if user.dispatcher?
      can :manage, Spool
      can :manage, Cell
      can :manage, Product
      can :read, Order
      can :manage, Task
      can :manage, Machine
      can :read, Scale
      can :read, Printer
    end

    if user.topmanager?
      can :read, Order
      can :read, History
      can :read, Spool
      can :read, Cell
      can :read, Product
      can :manage, :report
    end

    #manager dispatcher topmanager administrator  
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