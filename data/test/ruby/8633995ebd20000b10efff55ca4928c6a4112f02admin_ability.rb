class AdminAbility
  include CanCan::Ability

  def initialize(user)
    if Role.find(:all, :include=>:admin_users, :conditions => ["admin_users.id = ? AND name = ?", user.id, "Root"]).count > 0
       can :read, Category
       can :manage, Category
       can :read, TeamMember
       can :manage, TeamMember
       can :read, Role
       can :manage, Role
       can :read, User
       can :manage, User
       can :read, AdminUser
       can :manage, AdminUser
       can :read, Promotion
       can :manage, Promotion
       can :read, PromotionCategory
       can :manage, PromotionCategory
       can :read, PromotionPaymentStatus
       can :manage, PromotionPaymentStatus
       can :read, ActiveAdmin::Page, :name => "Store"
    end
    can :read, Attachment
    can :manage, Attachment
    can :read, Gallery
    can :manage, Gallery
    can :read, GalleryImage
    can :manage, GalleryImage
    can :read, Event
    can :manage, Event
    can :read, Post
    can :manage, Post
    can :read, Attachment
    can :manage, Attachment    
    can :read, AdminUser, :id => user.id
    can :manage, AdminUser, :id => user.id
    can :read, ActiveAdmin::Page, :name => "Dashboard"
  end

end
