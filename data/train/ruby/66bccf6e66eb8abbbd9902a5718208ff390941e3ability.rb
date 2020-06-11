class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    
    can :read, :all
    
    if user.persisted? 
      can :create, Post
      
      can :manage, Post if user.manage_all_posts?

      can :manage, Comment if user.manage_all_comments?

      can :manage, Role if user.manage_all_roles?

      can :manage, User if user.manage_all_users?
      
      %w(user role post comment).each do |resource|
        user.roles.find_all_by_title("manage_#{resource}").each do |item|
          can :manage, resource.classify.constantize, :id => item.item_id
        end
      end
      
      can :manage, Post, :user_id => user.id
     
      can :create, Comment

      can :manage, Comment, :user_id => user.id

      can :manage, User, :id => user.id
    end

    if user.admin?
      can :manage, :all
    end      
  end
end
