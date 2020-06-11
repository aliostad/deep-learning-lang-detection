class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.has_role? :admin
      can :manage, :all
      can :manage, PixiPost
      can :manage, Category
      can :manage, Transaction
      can :manage, BankAccount
      can :manage, CardAccount
      can :manage, FavoriteSeller
      can :manage, Invoice
      can :manage, User
      can :manage, Site
      can :access, '/pending_listings'
      can :manage_items, User
      can :manage_pixi_posts, User
      can :manage_orders, User
      can :manage_users, User
      can :view_dashboard, User
    else
      can :read, :all
      can [:read, :update], User do |usr|
        usr.try(:user) == user
      end

      can :read, Category
      can [:create, :read, :update], Transaction, :user_id => user.id

      can [:crud, :remove], Post, :user_id => user.id
      can [:read, :update, :remove], Post, :recipient_id => user.id

      can [:crud, :remove, :reply], Conversation, :user_id => user.id
      can [:read, :update, :remove, :reply], Conversation, :recipient_id => user.id

      can :crud, TempListing do |tmp|
        tmp.try(:user) == user
      end

      can [:crud, :sent, :remove], Invoice, :seller_id => user.id
      can [:show, :received, :decline], Invoice, :buyer_id => user.id

      can [:crud], BankAccount, :user_id => user.id
      can [:crud], CardAccount, :user_id => user.id
      can [:create, :read, :show, :refund], Transaction, :user_id => user.id

      can :update, Listing, :user_id => user.id

      can [:create, :index, :update], FavoriteSeller, :user_id => user.id
      can [:index], FavoriteSeller, :seller_id => user.id

      if user.has_role? :editor
        can [:read, :update], TempListing, status: 'pending'
        can :access, '/pending_listings'
        can :manage, PixiPost
        can :manage, Site
        can :manage_items, User
        can :manage_pixi_posts, User
        can :manage_orders, User
        can :view_dashboard, User
      end

      if user.has_role? :pixter
        can :manage_pixi_posts, User
        can [:read, :update], PixiPost, status: 'scheduled'
      end

      if user.has_role? :support
        can :manage_pixi_posts, User
        can [:read, :update], PixiPost, status: 'scheduled'
      end

      if user.has_role? :subscriber
        can :view_dashboard, User
      end
    end
  end
end
