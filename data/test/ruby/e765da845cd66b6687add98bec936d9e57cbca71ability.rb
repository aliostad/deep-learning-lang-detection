class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    
    if user.has_role?('Admin')
      can :manage, :all
      cannot :show, Product
      can :manage, Order
      
    elsif user.has_role?('Staff')
      can :manage, Product
      cannot :show, Product
      can :manage, Order
      
    elsif user.has_role?('Customer')
      can :show, Product
      can :manage, Order
      
    else
      # if user not log in
      can :show, Product
      can :new, Order
    end
    
  end
end
