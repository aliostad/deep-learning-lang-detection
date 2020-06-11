class AbilityDecorator
  include CanCan::Ability
    def initialize(user)
      # Agrega los permisos personalizados para el usuario de rol vendedor
      if user.respond_to?(:has_spree_role?) && user.has_spree_role?('vendedor')
        can [:admin, :manage], Spree::Order 
        cannot [:fire, :approve], Spree::Order 
        can [:admin, :manage], Spree::LineItem
        can [:admin, :manage], Spree::Shipment
        can [:admin, :manage], Spree::Stock
        can [:admin, :manage], Spree::Address
        can [:admin, :manage], Spree::State
        can [:admin, :manage], Spree::Country
      end
    end
end

Spree::Ability.register_ability(AbilityDecorator)