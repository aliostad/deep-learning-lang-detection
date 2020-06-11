# encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
  
    if user.admin?
      can :manage, :all
      
    elsif user.influencer?
      can :manage, Home
      can :manage, Influencer, :user_id => user.id

    elsif user.advertiser?
      can :manage, Home
      can :list, Influencer

    elsif user.affiliate?
      can :manage, Home
    else # Guest
      can :create, User
      can :create, Influencer
      can :create, Advertiser
      can :create, Affiliate      
    end
  end
end