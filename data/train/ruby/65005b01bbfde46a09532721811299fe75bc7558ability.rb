class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, Seed
    can :read, Page
    can :read, Chapter
    can :read, Scene
    can :read, Character
    can :read, Pedia
    cannot :index, Page

    if user.blank?
      can :create, User
    #elsif user.admin?
    # can :manage, :all
    else
      # Regular user
      can :create, Seed
      can :manage, Seed, user_id: user.id
      cannot :create, User
      can :manage, Page
      can :update, User, id: user.id
      can :manage, Character
      can :manage, Pedia
      can :manage, Chapter, user_id: user.id
      can :manage, Scene
      can :update, Scene

      if user.admin?
        can :manage, Group
        can :index, User
      end
    end
  end
end
