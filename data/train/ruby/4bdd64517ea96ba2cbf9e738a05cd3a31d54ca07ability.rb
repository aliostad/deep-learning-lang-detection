
# ability class is declared to give permissions on the particular module for the selected users only
class Ability
  
  include CanCan::Ability


# initialize the method for permissions
  def initialize(user)
      user ||= User.new # guest user

      # check if user is 'super' grant all permissions
      if user.role? :super
        can :manage, :all
        
        # check if user is 'admin' grant only 'update', 'new', 'manage' permissions
      elsif user.role? :admin
        can :update, :all
        can :new, :all
        can :read, [User]
        can :manage, [User]
        can :manage, [Category]
        
        # check if user is staff grant only 'read & 'manage' permissions
      elsif user.role? :staff
        can :read, [User]
        can :manage, [User]
        
        
      else
        can :manage, [Role]
      end
    end
  end
