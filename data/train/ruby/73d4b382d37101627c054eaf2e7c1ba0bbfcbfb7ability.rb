class Ability
  include CanCan::Ability
  
  def initialize(user)

    if user.registrar?
      can :manage , Trainee
      can :manage , StaffRecord
      can :registrar ,Task
      can :manage, Count
      can [:index,:update,:show] ,Examine
      can [:create,:destroy], Modify
    end
    
    if user.rightsman?
      can :manage , Perssion
    end

    if user.approval?
      can :manage , Count
      can [:index,:show,:create,:destroy,:proces_detail] , Examine
      can [:update,:create,:destroy] , Modify
      can :approval , Task
      can :manage ,Care
      can :manage ,StaffRecord
    end
  end
end
