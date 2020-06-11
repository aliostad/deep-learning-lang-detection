class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == 'admin'
      can :manage, :all
    elsif user.role == "risk_controller"
      can :manage,  Fund
      can :read,    ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can :manage,  Interest
    elsif user.role == "teller"
      can :manage,  Account
      can :read,    Billing
      can :read,    FundAccount
      can :read,    Fund
      can :read,    Invest
      can :read,    ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    elsif user.role == "account_manager"
      can :update,  AdminUser,  id: user.id
      can :manage,  HomsProperty
      can :manage,  HomsAccount
      can :manage,  ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    elsif user.role == "customer_service"
      can :manage,  BankCard
      can :read,    Account
      can :read,    Billing
      can :manage,  Comment
      can :manage,  User
      can :read,    Fund
      can :read,    Invest
      can :update,  AdminUser,  id: user.id
      can :manage,  News
      can :read,    Follow
      can :read,    ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    end
  end
end
