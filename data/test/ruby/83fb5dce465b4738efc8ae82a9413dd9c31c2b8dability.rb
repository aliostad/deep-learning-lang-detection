class Ability
  include CanCan::Ability

  def initialize(user)

    if user.role.name == 'Empleado'

      can [:update_password, :update_profile, :edit], [User]
      
      if user.can_inventory == true
        can :manage, Product
        can :manage, Category
        can :manage, TypeProduct
        can :manage, InputProduct
        can :manage, OutputProduct
      end

      if user.can_sales == true
        can :manage, Sale
      end

      if user.can_changes == true
          can :manage, Coupons
      end


      if user.can_consoles == true
        can :manage, Console
        can :manage, Reservation
        can :manage, ReservePrice
      end

      if user.can_customers == true
        can [:read, :edit], [Customer]
      end

    else
      can :manage, :all
    end

  end
end
