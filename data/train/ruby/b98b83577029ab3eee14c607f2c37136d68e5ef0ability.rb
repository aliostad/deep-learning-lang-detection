class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # Guest user
    can :create, Account
    can :signup, User   
    if user.role == 'site_admin'
      can :manage, :all
    elsif user.role == 'administrator'
      can [:show, :change_settings], Account
      can :manage, User
      can :manage, Customer
      can :manage, Confidence
      can :manage, Opportunity
      can :manage, Product
      can :manage, Target
    elsif user.role == 'salesman'
      can :show, Account
      can [:index, :show, :change_profile], User
      can :manage, Customer
      can :read, Confidence
      can :manage, Opportunity
    elsif user.role == 'associate'
      can :read, :all
    end
  end
end