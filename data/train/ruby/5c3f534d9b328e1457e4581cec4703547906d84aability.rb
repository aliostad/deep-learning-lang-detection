class Ability
  include CanCan::Ability

  def initialize(user, params=nil)
    user ||= User.new
    
    can [:new, :index], LogBook
    
    can :show, LogBook do |log_book|
      user.can_view_world_objects_in?(log_book)
    end
    
    unless user.new_record?
      can :manage, LogBook do |log_book|
        log_book.owned_by?(user)
      end
      
      can :manage, Section do |section|
        user.can_fully_manage?(section.log_book)
      end
      
      can :manage, SectionProperty do |section_property|
        user.can_fully_manage?(section_property.section.log_book)
      end
      
      can :manage, WorldObject do |world_object|
        user.can_manage_world_objects_in?(world_object.section.log_book)
      end
    end
  end
end
