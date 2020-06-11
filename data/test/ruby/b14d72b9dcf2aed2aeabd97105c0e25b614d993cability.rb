class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
      can :manage, :all
    else
      can :manage, User, id: user.id
      can :manage, Device, user_id: user.id
      can :manage, Invite, user_id: user.id
      can :manage, AppInvite, user_id: user.id

      can :read, Category
      can :read, Subcategory

      can :read, Star, user_id: user.id
      can :read, UserBadge, user_id: user.id
      can :read, Badge

      can :manage, Post, user_id: user.id
      can :read, Post
      can :manage, PostImage, post: { user_id: user.id }
      can :manage, Item, post: { user_id: user.id }
      can :read, Item
      can :manage, Offer, user_id: user.id
      can :manage, Offer, item: { post: { user_id: user.id }}
      can :read, Offer
      can :manage, Question, user_id: user.id
      can :read, Question
      can :manage, FlaggedPost, user_id: user.id

      can :manage, FollowedCity, user_id: user.id
      can :read, City

      can :manage, WallPost, user_id: user.id
      cannot :read, WallPost
      
      can :manage, Follow, user_id: user.id
      can :read, Follow

      can :manage, Message, sender_id: user.id
      can :read, Message, recipient_id: user.id

      can :manage, Notification, user_id: user.id
      can :manage, Notification, actor_id: user.id
      can :read, Notification

      can :read, RelatedProduct
      
      cannot :manage, ItemTransaction

      cannot :manage, FacebookTestUser
    end
  end
end
