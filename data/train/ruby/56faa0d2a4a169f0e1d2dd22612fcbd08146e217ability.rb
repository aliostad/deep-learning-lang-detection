class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.is_student?
        can :create, Project
      elsif user.is_projects_coordinator?
        can :manage, Project
        can :manage, User
        can :manage, Proposal
        can :manage, Report
        can :manage, Review
      elsif user.is_supervisor?
        can :manage, Report, :supervisor_id => user.id
        can :manage, Report, :co_supervisor_id => user.id
        can :manage, Review , :user_id => user.id
      end
      can :manage, Project, :user_id => user.id
    end

  end
end
