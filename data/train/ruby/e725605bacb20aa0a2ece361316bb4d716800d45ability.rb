class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super?
      can :manage, :all
    elsif user.admin?
    elsif user.cms?
      can :manage, Coach
      can :manage, DynamicImage
      can :manage, ServiceCourse
      can :manage, Category
      can :manage, Banner
      can :manage, Tag
      can :manage, Activity
      can :manage, ActiveAdmin::Page, :name => 'Message'
      can :read, ActiveAdmin::Page, :name => 'Dashboard'
    elsif user.market?
      can [:read, :create, :update], Service
      can :manage, ServiceDynamic
      can :manage, ServiceMember
      can :manage, ServicePhoto
      can :manage, ServiceCourse
      can [:read, :create, :update], AdminUser
      can :read, ActiveAdmin::Page, :name => 'Dashboard'
    elsif user.operator?
      can :manage, Banner
      can :manage, Sku
      can :manage, Coupon
      can :read, Enthusiast
      can :manage, Service
      can :read, ServiceDynamic
      can :read, ServiceMember
      can :read, ServicePhoto
      can :manage, ServiceCourse
      can :read, Coach
      can :manage, Report
      can :manage, Feedback
      can :manage, Overview
      can :read, Order
      can :manage, Activity
      can :manage, ActiveAdmin::Page, :name => 'Message'
      can :manage, ActiveAdmin::Page, :name => 'HitAndOnline'
      can :manage, Retention
      can :manage, ActiveAdmin::Page, :name => 'Dashboard'
      can :manage, DynamicImage
      can :manage, Category
      can :manage, Tag
      can :manage, CrawlDatum
      can :manage, News
    elsif user.superadmin
    elsif user.sales?
    elsif user.front_desk?
    elsif user.finance?
    elsif user.store_manager?
    elsif user.store_admin?
    else
    end
  end
end