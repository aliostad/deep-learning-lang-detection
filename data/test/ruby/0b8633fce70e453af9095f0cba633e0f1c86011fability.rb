class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Initiative, visible: true
    can :read, Comment
    can :read, Antraege
    can :read, Category
    can :read, Neuigkeiten
    can :read, Page
    can :read, Construction
    unless user.blocked?
      can :create, Comment
    end
    if user.superadmin?
      can :manage, :all
    elsif user.persisted?
      if user.admin?
        can :read, :all
        can :manage, Comment
        can :manage, Initiative
        can :manage, Banner
        can :manage, Page
        can :manage, Antraege
        can :manage, Category
        can :manage, Neuigkeiten
        can :manage, Widget
        can :manage, WidgetPlacement
        can :manage_users, User
        can :destroy, User
        can :assign_moderator, User
        can :remove_moderator, User
        can :block, User
        can :unblock, User
        can [:edit_note, :update_note], User
      end
      if user.moderator?
        can :manage_users, User
        can :destroy, User
        can :read, Initiative
        can [:edit, :update], Initiative
        can :manage, Comment
        can :manage, Category
        cannot :destroy, Category
        can :manage, Category
        can :manage, Neuigkeiten
        can [:edit, :update, :create], Antraege
        can [:edit_note, :update_note], User
      end

      can [:edit, :update], Initiative, user_id: user.id
      can [:edit, :update], Neuigkeiten, user_id: user.id
      can :subscribe, Initiative
      can :unsubscribe, Initiative
      can :unsupport, Initiative
      can :support, Initiative
      can [:show], User
      can [:contact], Initiative
      can [:contact_submit], Initiative
      can [:contact_moderator], Initiative
      can [:contact_moderator_submit], Initiative

      unless user.blocked?
        can :create, Initiative
        can :create, Neuigkeiten
      end

      can :update, Initiative, user_id: user.id
    end
  end
end
