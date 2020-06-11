class Ability
  include CanCan::Ability

  def initialize(employee)
    employee ||= Employee.new

    if employee.admin?
      can :manage, :all
    else
      can :manage, Address,   employee: { id: employee.id }
      can :manage, NextOfKin, employee: { id: employee.id }
      can :manage, Phone,     employee: { id: employee.id }
      can :manage, Spouse,    employee: { id: employee.id }

      can :read, Competency,    employee: { id: employee.id }
      can :read, Qualification, employee: { id: employee.id }
      can :read, MedicalRecord, employee: { id: employee.id }
      can :read, TradeCareer,   employee: { id: employee.id }
      can :read, Event,         employee: { id: employee.id }

      employee.assignments.active.each do |assignment|
        child_employees_ids = assignment.role.child_employees_ids
        line_employees_ids =  assignment.role.line_employees_ids

        if child_employees_ids.any? || line_employees_ids.any?
          can :index, Employee

          child_employees_ids.each do |id|
            if id != employee.id
              can :manage, Employee,      id: id
              can :manage, Address,       employee: { id: id }
              can :manage, NextOfKin,     employee: { id: id }
              can :manage, Phone,         employee: { id: id }
              can :manage, Spouse,        employee: { id: id }
              can :manage, Competency,    employee: { id: id }
              can :manage, Qualification, employee: { id: id }
              can :manage, MedicalRecord, employee: { id: id }
              can :manage, TradeCareer,   employee: { id: id }
              can :manage, Event,         employee: { id: id }
            end
          end

          line_employees_ids.each do |id|
            can :read, Employee, id: id
            can :read, Phone, employee: { id: id }
          end
        end
      end
    end
  end
end
