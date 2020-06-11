# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :read, :new, :create, :edit, :update, :destroy, :copy, :to => :change
    alias_action :read, :create, :to => :read_create

    can :read, ActiveAdmin::Page, :name => "Dashboard"
    can :manage, Diet
    can :manage, Plan
    can :manage, PlanItem
    can :manage, PlanItemIngredient
    can :manage, Dish
    can :manage, Eaten

    #can :read, Ingredient
    #can :change, Ingredient, :ration => {:user_id => user.id}
    can :manage, Ingredient

    can :manage, ActiveAdmin::Page, :name => "Settings"
    can :manage, Ration
    can [:change, :preview, :preview_short], Post, :user_id => user.id

    # A super_admin can do the following:
    if user.has_role? 'admin'
      can :manage, :all
      can :manage, User
      can :manage, Role
      can :manage, ActiveAdmin::Comment

    end

  end
end

