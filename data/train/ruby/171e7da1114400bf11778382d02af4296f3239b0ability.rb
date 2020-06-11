class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      can :manage, [Booking, Room, Article]
      can :manage, User do |u|
        user == u
      end
      can :read, User
    elsif user.customer?
      can :read, [Room, Article]
      can :create, Booking
      can [:destroy, :show], Booking do |b|
        user == b.user
      end
      can :manage, User do |u|
        user == u
      end
    end
  end

end
