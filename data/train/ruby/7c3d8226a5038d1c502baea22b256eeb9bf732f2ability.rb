class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can [:show, :following, :followers, :index, :send_message], User
      can [:edit, :details, :update], User, :user_id == user.id
      can :manage, Project
      can :manage, Attachment
      can :manage, Member
      can :manage, Milestone
      can :manage, Document
      can :manage, Phase
      can :manage, Activity
      can :manage, Report
    end
  end
end


