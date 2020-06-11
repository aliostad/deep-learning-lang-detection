class Ability
  include CanCan::Ability

  def initialize(admin)
    # Define abilities for the passed in user here. For example:
    #user ||= User.new # guest user (not logged in)
    
    #if user.roles.size == 0
    #  can :read, :all #for guest without roles
    #end

    admin.roles.each { |role| send(role) }

  end


  def course_manager
    can :manage, Course
  end

  def user_manager
    can :manage_user, User, :type => 'User'
    can :manage, Message
    #can :manage_admin, User, :type => 'User'

    #cannot :manage, User, :type => 'Admin'
  end

  def manager
  end

  def admin_manager
    can :manage_user, User
    can :manage, Message
    can :manage_admin, Admin
  end

  def order_manager
    can :manage, UserOrder
  end

  def service_manager
    can :manage, Message
  end

  def marketing_manager
    can :manage, Ad
    can :manage, Page
    can :manage, Seo
  end

  def admin
    #course_manager
    #user_manager
    #order_manager
    #service_manager
    can :manage, :all
  end
end
