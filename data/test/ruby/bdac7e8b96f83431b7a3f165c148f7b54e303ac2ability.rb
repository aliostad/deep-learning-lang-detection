class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    return unless @user

    user_access

    @user.roles.each do |role|
      __send__("#{role.role}_access")
    end
  end

private

  def user_access
    can :manage, Filter, user_id: @user.id
  end

  def administrator_access
    can :read, ActiveAdmin::Page, name: "Dashboard"

    can :manage, MailAlias
    can :manage, Filter
    can :manage, Group
    can :manage, User
  end

  def group_administrator_access
    can :read, ActiveAdmin::Page, name: "Dashboard"

    can :manage, Filter, user: {group_id: @user.group_id}
    can :manage, User, group_id: @user.group_id
  end
end
