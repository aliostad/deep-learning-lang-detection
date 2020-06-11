class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role.name == Role::ROLES[:admin]
      can :manage, Account, id: user.account.id # admin can manage only his own account
      can :manage, User, account_id: user.account.id # admin can manage only users of his account
      can :manage, SubscriptionPayment, account_id: user.account.id # manage only his own account's payments
    elsif user.role.name == Role::ROLES[:superuser]
      can :manage, :all
    end
  end
end
