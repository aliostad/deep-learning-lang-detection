class Ability
  include CanCan::Ability
  
  def initialize(user)
    can :manage, ActiveAdmin::Page, name: "Dashboard"#, namespace_name: :admin
    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      can :manage, :all
      cannot :manage, SiteConfig
      cannot :manage, Admin, email: Setting.admin_emails
    elsif user.site_editor?
      can :manage, :all
      cannot :manage, SiteConfig
      cannot :manage, Admin
      cannot :destroy, :all
    elsif user.marketer?
      cannot :manage, :all
      can :read, :all
      cannot :read, SiteConfig
      cannot :read, Admin
    end
  end
end