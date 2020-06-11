class Ability
  include CanCan::Ability

  def initialize(user)
    #Missions
    can :manage, :all if user.role == "compagnie"
    can :manage, Mission if user.role == "compagnie"
    cannot :manage, Mission if (user.role =="personnel") || (user.role =="section") || user.role.nil?

    can :manage, Roster, :user_id => user.id if (user.role =="personnel") || user.role.nil?
    can :read, User, :id => user.id if (user.role =="personnel") || user.role.nil?
    can :read, User if user.role == "section"

    can :manage, Roster if user.role == "compagnie" || user.role == "section"


  end
end