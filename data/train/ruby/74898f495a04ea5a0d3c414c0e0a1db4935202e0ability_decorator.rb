module Spree
  class AbilityDecorator
    include CanCan::Ability

    def initialize(user)
      user ||= User.new
      if user.has_spree_role? "sale"
        can :manage, Adjustment
        can :manage, Order
        can :manage, LineItem
        can :manage, Payment
        can :manage, Shipment
        can :read, Product
        can :index, Product
        can :admin, Product
        can :manage, Product
        can :index, Variant
        can :admin, Variant
        can :manage, Variant
        can :index, Image
        can :manage, Image

        can :manage, User
        can :index, User
        can :admin, User

        can :manage, ShareFile
        can :index, ShareFile
        can :admin, ShareFile

        can :manage, Promotion
        can :index, Promotion
        can :admin, Promotion

        can :manage, Page
        can :index, Page
        can :admin, Page
        
      end
      if user.has_spree_role? "admin"
        can :manage, Instruction
      end
    end
  end
end
Spree::Ability.register_ability(Spree::AbilityDecorator)