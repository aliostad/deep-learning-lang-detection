# Defines permissions of different user roles
#
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user # Fail if guest user

    # Default permissions
    can :read, :all
    can :export_member, Offering

    if user.is? :instructor
      can :manage, Offering do |offering|
        offering.taught_by? user
      end
      cannot :destroy, Offering
      can :profile, User
      can :update, User, :id => user.id
    end
    if user.is? :staff
      can :manage, Course
      can :manage, AcademicTerm
      can :manage, Outcome
      can :manage, OutcomeGroup
      can :manage, Offering
      can :manage, ContentGroupName
      can :manage, :all
    end
    if user.is? :admin
      can :manage, :all
    end
  end

end
