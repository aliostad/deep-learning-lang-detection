class Ability
  include CanCan::Ability
  
  def initialize(user)
      user ||= User.new # guest user (not logged in)
      if user.admin?
         can :manage, :all
      else
          can :manage, Project, lead_id: user.id
          can :manage, ProjectCollaborator, collaborator_id: user.id
          can :manage, Datum, project_id:  user.collaborations.map(&:id)
          can :manage, Datum, project_id:  nil
          can :read, Project
          can [:read,:update], User, id: user.id
      end
  end
end
