class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

      if user.has_role?('Admin')
        can :manage, :all
      
      elsif user.has_role?('Manager')
        can [:index], Order
        can :manage, User
        can :manage, Food
        can :manage, Drink
      
      elsif user.has_role?('Chef')
        cannot :manage, User
        cannot :manage, Food
        cannot :manage, Drink
        
        can [:edit, :update, :show], User, id: user.id
        can [:index, :update_foods_status, :update_drinks_status], Order
      
      elsif user.has_role?('Waiter')
        cannot :manage, User
        cannot :manage, Food
        cannot :manage, Drink
        
        can [:edit, :update, :show], User, id: user.id
        cannot [:update_foods_status, :update_drinks_status], Order
        can [:index, :show, :new, :edit, :create, :update, :destroy], Order
      
      else
        can :index, Order
      end
  end
end
