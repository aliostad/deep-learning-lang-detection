class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.roles.blank?
      cannot :manage, ManageController
    else
      can :manage, ManageController
      if user.admin?
        can :manage, :all
      end
      if user.has_role?("OrderManager")
        can :deliver, Order
      end
      if user.has_role?("IssueManager")
        can :manage, Message
        can :manage, Reply
        can :manage, OrderAdjustment
        can :refund, Order
        can :change, Order
      end
      if user.has_role?("BillManager")
        can :manage, Deposit
      end
      if user.has_role?("PurchaseManager")
        can :manage, PurchaseProduct
        can :manage, Message
        can :manage, Reply
      end
    end
  end
end
