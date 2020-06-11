module Pyrite
  class Ability
    include CanCan::Ability

    def initialize(usi_user)
      user = Pyrite::User.where(:id => usi_user.try(:id)).first || Pyrite::User.new
      if user.new_record?
        user.role = Role.where(const_name: 'anonymous').first
      else
        can :manage, :my
        can :read, :pyrite_dashboard
      end

      if user.pyrite_admin? || user.superadmin?
        can :read, :dashboard
        can :manage, Settings
        can :manage, Block
        can :manage, Building
        can :manage, Lecturer
        can :manage, AcademicYear
        can :manage, AcademicYear::Event
        can :manage, AcademicYear::Meeting
        can :manage, Block::Variant
        can :manage, Group
        can :manage, Room
        can :manage, Employee
        can :manage, Subject
        can :read, :timetables
        can :manage, :reservations
        can :print, :timetables

        can :manage, :own_settings
      else
        can :read, :timetables
        can :print, :timetables
      end
    end
  end
end
