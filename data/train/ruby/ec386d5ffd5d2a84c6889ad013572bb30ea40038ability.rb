class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)

    if user.role? :member
        can :manage, Wiki, :user_id => user.id, :private => false
    end

    if user.role? :premium
        can :manage, Wiki, :user_id => user.id
        can :manage, Wiki, :collaborations => {:user_id => user.id}
        can :manage, Collaboration

    end

    if user.role? :admin
        can :manage, :all
    end
    can :read, Wiki, private: false
  end
end
