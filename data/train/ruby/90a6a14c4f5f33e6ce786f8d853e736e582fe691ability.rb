class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :view, to: :read

    can :read, Camp, closed: false
    can :read, User
    can :create, User
    can :read, Reference
    can :read, License
    can :read, Publisher
    can :read, Post
    can :read, Membership

    can :read, CampShelf
    can :read, UserShelf

    can :read, Tag


    if user.present?
      can :update, Camp do |camp|
        camp.member?(user)
      end
      can :create, User
      can :manage, User, id: user.id
      can :update, License

      can :create, Reference
      can :manage, Reference, publisher_id: nil

      can :add_to, CampShelf

      can :create, UserShelf
      can(:add_to, UserShelf) do |shelf|
        shelf.open? or shelf.members.include?(user) or shelf.collaborators.include?(user)
      end
      can :manage, UserShelf, user_id: user.id

      can(:manage, ShelfItem) {|item| can? :add_to, item.shelf }

      can :manage, Tagging
      can :create, Tag

      can :manage, Membership do |membership|
        can? :manage, membership.resource
      end

      if user.admin?
        can :manage, Camp
        can :manage, Reference
        can :update, User
        can :manage, License
        can :manage, Color
        can :manage, Publisher
        can :manage, CampShelf
        can :manage, UserShelf
        can :manage, Post
        can :manage, MediaBite
      end

      if user.super?
        can :manage, User
      end
    end
  end
end
