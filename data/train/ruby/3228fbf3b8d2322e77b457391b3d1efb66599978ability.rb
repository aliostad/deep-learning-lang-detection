class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is? :admin
      can :manage, :all
      cannot :create, Gym
    elsif user.is? :leader
      can :manage, :all

      cannot :manage, Company
      can [:show, :update], Company
      if user.company.nil?
        can [:create], Company
      end

      can :manage, GymGroup

      cannot :manage, Gym
      can [:read, :create, :update], Gym

      can :manage, User, User.all do |u|
        user.company.users.include?(u)
      end

      cannot :destroy, User
      cannot :manage, VenueType
      cannot :manage, City
      cannot :manage, Area
      cannot :manage, PaymentMethod
      cannot :manage, UserAgreement
    elsif user.is? :manager
      can :manage, :all

      cannot :manage, Company
      cannot :manage, GymGroup
      cannot :manage, User
      cannot :manage, CardType
      cannot :manage, CardCharge

      cannot :manage, Gym
      can :read, Gym
      
      cannot :destroy, User
      cannot :manage, VenueType
      cannot :manage, City
      cannot :manage, Area
      cannot :manage, PaymentMethod
      cannot :manage, UserAgreement
    else
      can [:read, :create, :update], Gym
      can :manage, GymImage
    end
  end
end
