class Ability 
  include CanCan::Ability

  def initialize(user)
    if user.is_superadmin?
      can :manage, :all
    else
      can :read, :all
      if user.is_editor_admin?
        can :manage, User do |user|
          user.roles.size == 1 && user.is_editor_user?
        end
        can :manage, Admin
        can :manage, Statistic
      elsif user.is_provider_admin?
        can :manage, User do |user|
          user.roles.size == 1 && user.is_provider_user?
        end
        cannot :manage, Admin
        can :manage, Statistic
      elsif user.is_provider_user?
        cannot :manage, Admin
        can :manage, Statistic
      elsif user.is_editor_user?
        cannot :read, [Statistic, Admin]
      end
    end
  end
end
