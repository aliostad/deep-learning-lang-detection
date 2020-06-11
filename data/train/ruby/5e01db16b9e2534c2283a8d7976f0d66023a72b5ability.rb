class Ability
  include CanCan::Ability

  def initialize(user)
    case user.try(:role).try(:name)
    when 'Administrator'
      can :manage, Classification
      can :manage, ClassificationType
      can :manage, Subject
      can :manage, SubjectHasClassification
      can :manage, SubjectHeadingType
      can :manage, SubjectHeadingTypeHasSubject
      can :manage, SubjectType
      can :manage, WorkHasSubject
      can :manage, Manifestation
    when 'Librarian'
      can :read, Classification
      can :read, ClassificationType
      can :read, Subject
      can :manage, SubjectHasClassification
      can :read, SubjectHeadingType
      can :read, SubjectHeadingTypeHasSubject
      can :read, SubjectType
      can :manage, WorkHasSubject
      can :read, Manifestation
    when 'User'
      can :read, Classification
      can :read, ClassificationType
      can :read, Subject
      can :read, SubjectHasClassification
      can :read, SubjectHeadingType
      can :read, WorkHasSubject
      can :read, Manifestation
    else
      can :read, Classification
      can :read, ClassificationType
      can :read, Subject
      can :read, SubjectHasClassification
      can :read, SubjectHeadingType
      can :read, WorkHasSubject
      can :read, Manifestation
    end
  end
end
