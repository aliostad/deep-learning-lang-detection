class Ability
  include CanCan::Ability

  def initialize(user = nil)
    user ||= User.new

    cannot :manage, :all

    can :manage, :all if user.admin?

    can :manage, Resource, user_id: user.id

    can :create, SavedSearch

    can :read, Group
    can :read, Address
    can :read, Tag
    can :read, Tagging
    can :read, Comment
    can :read, Resource
    can :read, ResourceCategory
    can :read, Page
    can :read, User, public: true

    can :read,   User, id: user.id
    can :delete, User, id: user.id
    can :update, User, id: user.id

    can :manage, Note,        user_id: user.id

    can :create, Tagging
    can :manage, Tagging,     user_id: user.id

    can :manage, Address,     addressable: user
    can :manage, SavedSearch, user_id: user.id
    can :manage, Comment,     user_id: user.id

    can :create, Kid
    can :manage, Kid do |kid|
      kid.guardianships.where(user_id: user.id).any?
    end
  end
end
