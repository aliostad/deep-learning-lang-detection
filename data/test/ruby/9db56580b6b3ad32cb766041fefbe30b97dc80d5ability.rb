class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :edit, :update, :create, :destroy, :to => :manage_own
    alias_action :read, :edit, :update, :create, :destroy, :to => :manage_department
    alias_action :read_own, :edit, :update, :to => :manage_own_excluding_creation

    user ||= User.new
    if user.new_record?
      user.role = Role.where(const_name: 'anonymous').first
    else
      can :manage, :my
    end

    if user.anonymous?
      can :read, Diamond::Thesis
    elsif user.student?
      can :manage, User,
        {:id => user.id}
      can :read, Diamond::Thesis
      can :create, Diamond::ThesisEnrollment
      can [:read, :update], Graphite::ElectiveBlock
      can :read, Graphite::ElectiveBlock::ElectiveModule
    elsif user.supervisor?
      can :manage, User,
        {:id => user.id}
      can :read, Employee
      can :read, Student
      can :manage_own, Diamond::Thesis,
        {:supervisor_id => user.verifable_id}
      can :manage, Diamond::ThesisEnrollment,
        {:thesis => {:supervisor_id => user.verifable_id}}
      can :manage, Diamond::ThesisMessage
      can :read, :theses_reports
    elsif user.department_admin?
      can :manage_department, Diamond::Thesis,
        {:department_id => user.verifable.department_id}
      can :manage, User,
        {:id => user.id}
      can :read, Employee
      can :manage, Diamond::ThesisEnrollment
      can :manage, Diamond::ThesisMessage
      can :manage, DepartmentSettings,
        {:department_id => user.verifable.department_id}
      can :read, Student
      can :manage, :theses_reports
    elsif user.admin?
      can :manage, User
      can :manage, Employee
      can :manage, Student
      can :manage, Settings
      can :manage, Diamond::Thesis
      can :manage, Diamond::ThesisEnrollment
      can :manage, Diamond::ThesisMessage
      can :manage, EnrollmentSemester
      can :manage, :theses_reports
      can :manage, :elective_blocks_reports
      can :manage, Graphite::ElectiveBlock
      can :manage, Graphite::ElectiveBlock::ElectiveModule
    elsif user.superadmin?
      can :manage, :all
    end

  end

end
