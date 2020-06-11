class Ability
  include CanCan::Ability

  def initialize(user)
    user ||=  User.new # guest user

    if user.roles.empty? or user.nil?
      can :read, Magister
      can :read, Course
    end

    if user.role?(:admin)
      can :manage, :all
    end

    if user.role?(:coordinator)
      can :manage, Magister
      
      can :manage, Magister do |magister|
        if !magister.user.nil?
          magister.user == user || user.role?(:admin)
        else
          user.role?(:admin) || user.role?(:coordinator)
        end 
      end
      
      can :manage, Course
      can :manage, Pensum
      can :manage, Offer
      can :manage, CoursesPensum
      can :manage, Enrollment
      can :manage, Annotation
      can :manage, Homologation
      can :read, User
      can :read, Plan
      can :index_enrollment_assignation, User
      can :manage, Transfer
      
      can :edit, User do |usr|
        usr == user || user.role?(:admin) 
      end
    end

    if user.role?(:student)
      can :read, Course
      can :read, Magister
      can :read, Pensum
      can :read, Offer
      can :manage, Preinscription
      can :read, Homologation
      can :create, Homologation
      can :read, Annotation

      can :show, User do |usr|
        usr == user || user.role?(:admin) || user.role?(:coordinator)
      end
      
      can :edit, User do |usr|
        usr == user || user.role?(:admin) 
      end

      can :create, Plan
      
      can :manage, Plan do |pl|
        pl.user == user
      end

      can :create, Transfer

      can :manage, Transfer do |t|
        t.user == user
      end

    end
  end
end