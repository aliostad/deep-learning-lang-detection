class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if user.try(:role)
      send(user.role)
    else
      guest
    end

  end

private
    def guest
    end

    def user
      guest
      can :read, Drill
      can [:index, :for_me], Schedule
      can :read, Schedule, subject_id: @user.id
      can :read, Slot
    end

    def manager
      guest
      can :read, User
      can :manage, Drill
      can :manage, Tag
      can :manage, Schedule
      can :manage, Slot
    end

    def admin
      manager
      can :manage, User
    end
end
