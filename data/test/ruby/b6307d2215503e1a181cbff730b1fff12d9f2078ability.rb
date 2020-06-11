class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
      if user.admin?
        can :manage, Article
        can :manage, Office
        can :manage, NewsItem
        can :manage, ContentPage
        can :manage, PromoSlide
        can :manage, FrontPageBanner
        can :manage, TextBanner
      else
        can :read, NewsItem
        can :read, Article
        can :read, Office
        can :read, ContentPage
        can :read, PromoSlide
        can :read, FrontPageBanner
        can :read, TextBanner
      end
  end
end
