class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.role == "super_admin"
      can :manage, :all
    elsif user.role == "admin"

      can :manage, [Level,Post,Project,Artwork,Contact]

      can :manage, User
      cannot :see_super_admins, User
      cannot :manage, User, :role => "admin"
      cannot :manage, User, :role => "super_admin"
      can :manage, User, :id => user.id

    elsif user.role == "publisher"

    else
      can :read, :all
      can :read, User, :id => user.id
      can :edit, User, :id => user.id
    end
  end
end
