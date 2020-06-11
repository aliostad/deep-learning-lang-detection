module Spree
  class AbilityDecorator
    include CanCan::Ability
    def initialize(user)
      if user.respond_to?(:has_spree_role?) && user.has_spree_role?('host')
        can [:manage], Spree::Order
        can [:admin,  :manage], Spree::Product       
        can [:admin,  :manage], Spree::OptionType
        can [:admin,  :manage], Spree::OptionValue
        can [:admin,  :manage], Variant
        can [:admin,  :manage], ProductProperty
        can [:admin,  :manage], Property
      end
    end
  end
  Ability.register_ability(AbilityDecorator)
end
