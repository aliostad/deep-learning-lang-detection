class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new
    

    if user.role? :admin
      can :manage, :all
    elsif user.role? :moderator
      can :manage, [ Article, Page]
    elsif user.role? :user
      can :read, [Article, Page]
      can :summarize, Article
      # can :read, [Article, Page]

      # manage products, assets he owns
      # can :manage, Comment do |comment|
      #   comment.try(:owner) == user
      # end
      # can :manage, Team do |team|
      #   team.try(:owner) == user
      # end
      
    else
      can :read, [Article, Page]
    end
  end
end