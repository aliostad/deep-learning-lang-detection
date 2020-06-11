class Ability
  include CanCan::Ability

  def initialize (user)  
    #can :manage, :all
    if user
      if user.admin?
        can :manage, AccrualType
        can :manage, User
        can :manage, Employee
        can :manage, Constants
        can :manage, Holiday
      end
      if user.hrmanager?        
        can :manage, Aid
        can :manage, DayoffMask
        can :manage, Department
        can :manage, Employee
        can :manage, EmployeesPosition
        can :manage, EmployeesPrevPosition
        can :manage, Holiday
        can :manage, Position
        can :manage, Premium
        can :manage, SickLeave
        can :manage, Vacation
      end
      if user.tableman
        can :manage, EmployeesVisit
        can :manage, DayoffMask
        can :read, Holiday
        can :read, Vacation
        can :read, SickLeave
      end
      if user.accountant
        can :manage, AccrualType
        can :manage, Position
        can :manage, Premium
        can :manage, Aid
        can :manage, :salary
      end
    end
  end


end
