class Ability

  include CanCan::Ability

  def initialize( user )
    user ||= User.new(role: nil)

    if user.is? :admin
      can :manage, :all
    elsif user.is? :vendor_admin
      can :manage, Item
      can :manage, Category
      can :manage, Order
      can :manage, Review
      can :manage, User, id: user.id
      can :manage, Vendor, vendor_id: user.vendor_id
    elsif user.is? :user
      can :read, Item
      can :read, Category
      can :create, Order
      can :read, Order
      can :manage, User, id: user.id
      can :manage, Review
    else
      can :read, Item
      can :read, Category
      can :read, Review
      can :create, User
    end
  end

end
