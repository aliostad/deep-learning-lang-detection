class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :update, :destroy, :to => :modify
    if user.has_role? :god
      can :manage, :all
    elsif user.has_role? :admin
      can :read, :all
      can :modify, User, id: user.id
      cannot :manage, Site
    elsif user.has_role? :artist
      can :modify, Post, user_id: user.id
      can :create, Post
      cannot :manage, Site
      cannot :manage, Page
      cannot :manage, Event
      cannot :manage, Artist
      cannot :manage, Residency
    end
  end
end
