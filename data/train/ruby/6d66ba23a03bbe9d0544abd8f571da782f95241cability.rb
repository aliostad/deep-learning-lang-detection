class Ability
  include CanCan::Ability

  def initialize(user)
    # guest user (not logged in)
    @user = user ||= User.new

    # Handle each user role within own method
    @user.roles.each { |role| send(role.name.downcase) }

    # for guest without roles
    if @user.roles.empty?
      
    end
  end

  # Define guest role
  def user
    can :read, :all
    can :create, Project
  end

  # Define viewer role (assigned by default to every registered user)
  def projectowner
    user
    can :manage, Project, user_id: @user.id
    can :manage, ProductBreakdownStructure, project: { user_id: @user.id }
    can :manage, Qualification, project: { user_id: @user.id }
    can :manage, Milestone, project: { user_id: @user.id }
    can :manage, Resource, project: { user_id: @user.id }
    can :manage, ResourceAllocationMatrix, project: { user_id: @user.id }
    can :manage, ResourceBreakdownStructure, project: { user_id: @user.id }
    can :manage, WorkBreakdownStructure, project: { user_id: @user.id }
    can :manage, WorkPackage, project: { user_id: @user.id }
  end

  def admin
    user
  end
end
