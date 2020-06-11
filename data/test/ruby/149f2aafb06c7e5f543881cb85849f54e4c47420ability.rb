class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new, :create, :edit, :update, :destroy, :to => :crud
    alias_action :new, :create, :to => :bill
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :manage, News
      can :manage, Category
      can :manage, Product
      can :manage, Specification
      can :manage, Brand
      can :manage, Bill
    else
      can :read, MotherCategory
      can :read, Brand
      can :read, Category
      can :show, Product
      can :show, News
      can :bill, Bill
    end
  end
end
