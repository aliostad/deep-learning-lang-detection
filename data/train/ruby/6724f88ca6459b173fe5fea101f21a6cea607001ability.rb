# Cancan authorizes users according to these rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.super_admin?
      can :manage, Role
      can :manage, User
      can :manage, Store
      can :manage, Product
      can :manage, Category
      can :manage, Order
      can :manage, :stores
      can :manage, :all
    end

    if user.admin?
      admin_store(user)
      admin_category(user)
      admin_product(user)
      admin_order(user)
    end

    if user.stocker?
      admin_product(user)
    end
  end

  def admin_store(user)
    can :manage, Store do |store|
      store.users.include?(user) if store
    end
  end

  def admin_category(user)
    can :manage, Category do |category|
      category.new_record? ||
        category.store.users.include?(user)
    end
  end

  def admin_product(user)
    can :manage, Product do |product|
      product.new_record? || product.store.users.include?(user)
    end
  end

  def admin_order(user)
    can :manage, Order do |order|
      order.store.users.include?(user) if order.store
    end
  end
end
