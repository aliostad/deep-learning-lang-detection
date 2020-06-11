class Ability
  include CanCan::Ability

  def initialize(user)
    # Guest
    unless user
      can :read, [Store, Category, Product, Order]
      can :create, [User, Order]
    else
      can :create, Store

      can :manage, Product do | p |
        p.store.users.include?(user)
      end

      can :manage, Category do | c|
        c.new_record? || c.store.users.include?(user)
      end

      can :read, Store do | store |
        store.stocker(user)
      end

      can :manage, Store do | store |
        store.admin(user)
      end

      can :manage, User, :id => user.id

      if user.platform_administrator
        can :manage, :all
      end
    end
  end
end
