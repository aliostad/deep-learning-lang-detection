class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, Role
      can :manage, User
      can :manage, Profile
      can :manage, Cat
      # can :manage, Site
      can :manage, Inventory
      can :manage, Tag
      can :manage, Integral
      can :manage, Vritualcard
      can :manage, Order
      can :manage, Comment
      can :manage, Product
      can :manage, ProductOrder
      can :manage, Invoice
      can :manage, PrizeAct
      can :manage, PrizeConfig
      can :manage, PrizeUserNumber
      can :manage, PrizeUser
      can :manage, WxMenu
      can :manage, Group
      can :manage, GroupOrder
      can :manage, Seckill
      can :manage, SeckillOrder
      can :manage, SiteConfig
      can :manage, Withdraw
      can :manage, Commission
      can :manage, Score
    elsif user.has_role? :provider
      can :manage, User
      can :manage, Profile
      # can :manage, Cat
      # can :manage, Site
      can :manage, Inventory
      can :manage, Tag
      can :manage, Integral
      can :manage, Vritualcard
      can :manage, Order
      can :manage, Comment
      can :manage, Product
      can :manage, ProductOrder
      can :manage, Invoice
      # can :manage, PrizeAct
      # can :manage, PrizeConfig
      # can :manage, PrizeUserNumber
      # can :manage, PrizeUser
      # can :manage, WxMenu
      can :manage, Group
      can :manage, GroupOrder
      can :manage, Seckill
      can :manage, SeckillOrder
      # can :manage, SiteConfig
      # can :manage, Withdraw
      # can :manage, Commission
    elsif user.has_role? :customer
      can :manage, Site
    else
      can :manage, Site
    end
  end
end
