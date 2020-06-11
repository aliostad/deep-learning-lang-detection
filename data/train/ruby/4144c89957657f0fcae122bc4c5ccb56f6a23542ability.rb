class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    if user.is_a? Admin
      can :manage, :admin_dashboard
      can [:edit, :update], Admin, id: user.id
      can :manage, TeachingAssistant
      can :manage, LabAssistant
    elsif user.is_a? TeachingAssistant and user.validated
      can :manage, :teaching_assistants_dashboard
      can [:edit, :update], TeachingAssistant, id: user.id
      can :manage, LabAssistant
    elsif user.is_a? LabAssistant and user.validated
      can :manage, :lab_assistants_dashboard
      can :manage, LabAssistant
    end
  end
end
