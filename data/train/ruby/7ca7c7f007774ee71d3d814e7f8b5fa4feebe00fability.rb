class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :read, :update, to: :cru
    alias_action :create, :read, to: :cr
    alias_action :read, :update, to: :ru

    user ||= User.new
    
    if user.superadmin?
        can :manage, :all
    elsif user.admin?
        can :manage, :all
        cannot :manage, VestjensMaster
        cannot :manage, User
        cannot :manage, PurchasePrice
        cannot :manage, PurchaseBill
        cannot :destroy, Recall
        cannot :destroy, Product
    elsif user.binnendienst?
        can :manage, Batch
        can :manage, PurchaseOrder
        can :read, PurchasePlanning
        cannot :destroy, PurchaseOrder
        can :manage, Structuremix
        can :cru, Fevalue
        can :cru, WeighingNote
        can :cru, Reject
        can :cru, Order
    elsif user.administratie?
        can :read, Batch
        can :cru, Supplier
        can :read, Contact
        can :read, Transporter
        can :ru, PurchaseOrder
        can :manage, PurchasePrice
        can :manage, TransPrice
        can :manage, PurchaseBill
        cannot :manage, Order
    elsif user.financieel?
        can :read, Batch
        can :cru, Supplier
        can :read, Contact
        can :read, Transporter
        can :ru, PurchaseOrder
        can :manage, PurchasePrice
        can :manage, TransPrice
        can :read, PurchaseBill
        cannot :manage, Order
    else
        can :read, :all
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
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
