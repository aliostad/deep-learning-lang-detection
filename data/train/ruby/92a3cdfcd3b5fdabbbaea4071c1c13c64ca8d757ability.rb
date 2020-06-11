class Ability
  include CanCan::Ability

  def initialize(user, session)
    user ||= User.new # guest user (not logged in)

    if user.is? :admin
      can :manage, :all
    elsif user.is? :user # registered user
      can :manage, User, :id => user.id
      can :manage, UserProperty, :user_id => user.id
      can :manage, UserAccount, :user_id => user.id
      can :read, Order, :user_id => user.id, :closed => true
      can :manage, Order, :user_id => user.id, :session => session, :closed => false
    else # guest
      can :create, Order
      can :manage, Order, :user_id => nil, :session => session, :closed => false
      can :manage, Order, :user_id => 0, :session => session, :closed => false
    end
  end
end
