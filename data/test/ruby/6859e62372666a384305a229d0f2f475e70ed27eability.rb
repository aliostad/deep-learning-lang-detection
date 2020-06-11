class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :supervisor
      can :manage, :all
    end
    
    if user.has_role? :manage_all_user
      can :manage, User
    end
    
    if user.has_role? :assign_roster
      can :manage, WorkingShiftStaff
      can :manage, ArrivalFlight
    else
      can :manage, ArrivalFlight, :user_id => user.id
    end
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
