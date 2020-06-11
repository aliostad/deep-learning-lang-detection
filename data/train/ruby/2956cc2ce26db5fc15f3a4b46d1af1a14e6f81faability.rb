class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.super?
        can :manage, :all
      elsif user.admin?
        can :manage, Blog
        can :manage, Comment
        can :manage, Illustration
        can :manage, Page
        can :manage, User
        
        
      elsif user.member?#ordinary user
        
        can :read, Blog
        can :create, Blog
        can :manage, Blog, :user_id => user.id
        can :create, Comment
        can :manage, Comment, :user_id => user.id  
        can :read, Illustration
        can :read, Page
        can :read, User
        can :manage, User, :id => user.id
       
      end
    # When not logged in
   else
     can :read, Blog
     can :read, Comment
     can :read, Illustration
     can :read, Page
     can :read, User
     #can :create, User# <----------- Uncomment this to alow users to signup by them self 
    end
  end
end
