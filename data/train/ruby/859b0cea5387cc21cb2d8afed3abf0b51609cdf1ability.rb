class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new
    can :manage, Opportunity if user.role == "recruiter"
    can :manage, :all if user.role == "admin"
    can :read, User if user.role == "recruiter"
    can :create, Applikation if user.role == "applicant"
    can :read, Opportunity
#    can :edit, @user #useless
    can :manage, user
#    can :manage, :all #poor man's Ability debugging
    
#    can :read, User do |resource|
#      resource == user
#    end
#    can :update, User do |resource|
#      resource == user
#    end
    
#    user ||= User.new #Guest
#    if user.role == "admin"
#      can :manage, :all 
#    elsif user.role == "recruiter"
#      can :manage, :opportunities
#    elsif user.role == "applicant"
#      can :manage, :applications
#      can :read, :opportunities
#    else
#      can :read, :opportunities
#    end
  end
end