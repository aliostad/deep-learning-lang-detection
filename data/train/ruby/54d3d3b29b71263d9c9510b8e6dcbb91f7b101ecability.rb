class Ability
  include CanCan::Ability

  def initialize(costumer)

    if costumer && costumer.admin?
        can :create, Book
        can :create, Category
end

    if costumer.is_a?(Costumer)
        can :manage, Order, costumer_id: costumer.id
        can :manage, OrderItem #, order.costumer_id: costumer.id
        can :manage, Costumer
         can :manage, Rating
        can :manage, Adress, costumer_id: costumer.id
        can :manage, BillingAdress, costumer_id: costumer.id
        can :manage, CreditCard, costumer_id: costumer.id     
    end
  
        can :read, Book
        can :read, Author
        can :read, Category
    

  end
end
