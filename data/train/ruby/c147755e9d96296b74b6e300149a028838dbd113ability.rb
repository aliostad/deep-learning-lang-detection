class Ability

  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.role? :admin
      can :manage, :all
    else
      can :read, :all

      cannot :read, Role
      cannot :read, RolesUser
      cannot :manage, Role
      cannot :manage, RolesUser
      can :new, Event
      can :create, Event

      cannot :index, Tag

      if user.role? :moderator
        can :manage, Tag
      end

      if user.role? :moderator
        can :manage, Event
      end

      # manage only own events
      can :manage, Event do |event|
        event[1].user_id == user.id
      end

      # manage only own posts
      can :manage, Post do |post|
        post[1].user_id == user.id
      end

      # manage only own album
      can :manage, PhotoAlbum do |photo_album|  
        photo_album[1].user_id == user.id
      end

      # manage only own personalities
      can :manage, UserCommon do |user_common|  
        user_common[1].user_id == user.id
      end

      # manage only own groups
      can :manage, Group do |group|  
        group[1].user_id == user.id
      end

      # manage only own comments
      can :manage, Comment do |comment|  
        comment[1].author_id == user.id || comment[1].commentable_id == user.id || (comment[1].commentable_type.to_s.eql?('Post') && Post.find(comment[1].commentable_id).user_id == user.id) || (comment[1].commentable_type.to_s.eql?('Group') && Post.find(comment[1].commentable_id).user_id == user.id)
      end

    end
  end
end