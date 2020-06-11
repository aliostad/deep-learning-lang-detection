class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    @user = User.find_by_id(user.id)
    if @user.id == 1
      can :manage, :all
      #can :index, Company
      #can :index, Branch
    elsif @user.role_id == 2
      can :manage, Tollbooth
      can :manage, Task
      can :manage, User
      can :manage, Client
      can :manage, Product
      can :manage, Order
      can :show, Company
      can :show, Branch
    elsif @user.role_id == 3
      can :show, Tollbooth, :id => @user.tollbooth_id
      can :index, Tollbooth, :id => @user.tollbooth_id
      can :manage, User, :tollbooth_id => @user.tollbooth_id
    elsif @user.role_id == 4
      can :show, User, :id => @user.id
      #can :show, Survey
      #can :new, Survey
      #can :create, Survey
    elsif @user.role_id == 5
      cannot :manage, :all 
    end
  end
end
