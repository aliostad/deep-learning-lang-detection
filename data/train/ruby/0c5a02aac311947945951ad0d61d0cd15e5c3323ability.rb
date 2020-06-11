class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    Rails.logger.debug("DEBUG:: #{user.role? :owner}")

    if user.role? :spectator
      can :read, :all
    end

    if user.role? :contributor
      can :manage, Survey
      can :manage, Clinic
      can :manage, Provider
      can :manage, Field
      can :manage, FieldChoice
    end

    if user.role? :owner
      can :manage, User
      can :manage, Team
    end


    if user.role? :superuser
      can :manage, :all
    end


    # if user.role? :superuser
    #   can :manage, :all

    # elsif user.role? :owner
    #   can :manage, :all

    # elsif user.role? :contributor
    #   cannot :manage, Team
    #   cannot :manage, User
    #   cannot :manage, Device

    # elsif user.role? :spectator
    #   can :read, :all
    #   cannot :manage, Device
    #   cannot :manage, User
    #   cannot :manage, Team

    # else
    #   can :create, Team
    # end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
