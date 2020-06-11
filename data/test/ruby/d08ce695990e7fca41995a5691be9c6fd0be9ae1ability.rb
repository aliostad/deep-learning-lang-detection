class Ability
  include CanCan::Ability

  def initialize(user)
    # can manage store memberships
    can :manage, Membership do |membership|
        membership.customer_id = user.customer_id
    end 
    
    # can manage own item purchases (inventory)
    can :manage, ItemPurchase do |item_purchase|
        item_purchase.purchase.customer_id = user.customer_id        
    end

    # can manage own shopping list
    can :manage, ShoppingListItem do |shopping_list_item|
        shopping_list_item.customer_id = user.customer_id
    end
  end
end
