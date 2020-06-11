module Spree
  class AdminAbility
    include CanCan::Ability

    ADMIN_ROLES = %w(admin:orders)

    def initialize(user)
      # All ADMIN roles can view the main admin page
      ADMIN_ROLES.each do |r|
        if user.has_spree_role?(r)
          can :manage, 'spree_overview_controller'
        end
      end

      if user.has_spree_role?('admin:orders')
        can :manage, 'spree_customer_details_controller'
        can :manage, nil  # This is due to a bug in Spree::Core OrdersController#load_order
        can :manage, Spree::Order
        can :manage, Spree::Payment
        can :manage, Spree::Shipment
        can :manage, Spree::Adjustment
        can :manage, Spree::ReturnAuthorization
      end

    end

  end
end
