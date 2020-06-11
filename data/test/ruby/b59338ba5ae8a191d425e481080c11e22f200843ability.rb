# The model that is responsible for defining roles with CanCanCan. Pretty self explanatory.
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :edss
      cannot :manage, :sysadmin
      cannot :access, :rails_admin
      cannot :manage, :admin
      cannot :manage, :myo
    	can :manage, :edss
    elsif user.has_role? :myo
      cannot :manage, :sysadmin
      cannot :access, :rails_admin
      cannot :manage, :admin
      cannot :manage, :edss      
      can :manage, :myo
    else
      cannot :manage, :sysadmin
      cannot :access, :rails_admin    	
      cannot :manage, :edss
      cannot :manage, :admin
      cannot :manage, :myo
    end
  end
end
