class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end

    # If you own the profile you can manage it
    can :manage, Profile do |profile|
      profile.user == user
    end

    # If the user exists they can manage education
    if user.persisted?
      can :manage, Education
      can :manage, Experience
      can :manage, Project
      can :manage, Skill
    end
  end
end
