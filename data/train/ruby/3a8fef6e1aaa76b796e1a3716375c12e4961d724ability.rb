class Ability
  include CanCan::Ability

  def initialize(user)
    role = user.roles.find(:first).role if user.present? && user.roles.present?
    user ||= User.new

    if role == "Admin"
      can :manage, :all
      can :view, :all
    elsif role == "Agent"
      can :manage, :Agent
      can :create, :read, [:User, :Claim, :EndUser]
      can :read, :all
    elsif role == "User"
      can :manage, EndUser
      can :manage, :EndUser
      can :update, :claim
    else
      can :manage, EndUser
    end
  end
end
