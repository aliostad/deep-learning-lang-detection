class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :attendant
      can :read,   Settings
      can :manage, Brand
      can :read,   Budget
      can :manage, BusinessDay
      can :manage, BusinessHour
      can :manage, BusinessHourException
      can :manage, Category
      can :manage, Component
      can :manage, ComponentModel
      can :read,   Covenant
      can :read,   CovenantSignature
      can :manage, Group
      can :manage, InventoryRecord
      can :manage, Kit
      can :manage, Loan
      can :manage, Location
      can :manage, Membership
      can :manage, Permission
      can :read,   Role
      can :manage, Training
      can :manage, User     # TODO: restrict this to certain attributes [:username, :email, :first_name, :last_name]
      can :read,   User
    else
      can :read, Brand
      can :read, BusinessDay
      can :read, BusinessHour
      can :read, Category
      can :read, Component
      can :read, ComponentModel

      # TODO: implement the ability for supervisors to edit groups?
      # can [:show, :edit, :update], Group, :memberships => { user_id: user.id, supervisor: true }

      if Settings.clients_can_see_equipment_outside_their_groups
        can :read, Kit, :worflow_state => 'circulating'
      else
        can :read, Kit, :groups => { :id => user.group_ids }
      end

      can :read, Location
      can :read, user.loans
      cannot :read, User
      can :read, user
      # https://github.com/ryanb/cancan/wiki/Defining-Abilities-with-Blocks
      # can :update, Project, ["priority < ?", 3] do |project|
      #   project.priority < 3
      # end
    end
  end

end
