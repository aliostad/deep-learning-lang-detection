class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.manager?

    can :manage, :application do
      user.permissions.any?
    end

    can :manage, Discipline do |discipline|
      user.methodologist_of? discipline.subdepartment
    end

    can :manage, WorkProgramm do |work_programm|
      can? :manage, work_programm.discipline
    end

    can :manage, Protocol do |protocol|
      can?(:manage, protocol.work_programm)
    end

    can :manage, WorkProgramm::PART_CLASSES do |part|
      can? :manage, part.work_programm
    end
  end
end
