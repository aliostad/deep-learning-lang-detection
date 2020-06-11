module Spree
	class AbilityDecorator
		include CanCan::Ability
	 
		def initialize(user)
		  user ||= User.new

      if user.respond_to?(:has_spree_role?) && user.has_spree_role?('shop_manager')

        can [:admin, :manage], Order
        can [:admin, :manage], Adjustment
        can [:admin, :manage], Payment
        can [:admin, :manage], Shipment
        can [:admin, :manage], ReturnAuthorization

        can [:admin, :manage], Spree::Admin::ReportsController
        can [:admin, :manage], Spree::InvoiceController

      end

		end
	end
	
	Ability.register_ability(AbilityDecorator)
end


