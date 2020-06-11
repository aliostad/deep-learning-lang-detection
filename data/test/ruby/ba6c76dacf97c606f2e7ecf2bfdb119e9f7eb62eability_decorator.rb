class AbilityDecorator
  include CanCan::Ability
  def initialize(user)
    can [:purchase_rc, :update_address], Spree.user_class, :id => user.id
    if user.has_spree_role?(:help_desk)
      # can :manage, :all
      can :manage, Spree::Order
      # can :manage, Spree::User
      can :manage, Spree::LensMetaPrescription
      can :manage, Spree::LensPrescription
      can :manage, Spree::Adjustment
      can :manage, Spree::Payment
      can :manage, Spree::Shipment
      can :manage, Spree::ReturnAuthorization
      can :manage, Spree::Variant
      can :manage, Spree::LineItem
      # can :manage, Spree::Product
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator)
