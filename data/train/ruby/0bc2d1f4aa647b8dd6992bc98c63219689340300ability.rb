class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.super?
        can :manage, :all
      elsif user.admin?
        can :manage, Banner
        can :manage, Blog
        can :manage, Comment
        can :manage, Gift
        can :manage, Goals
        can :manage, Illustration
        can :manage, Page
        can :manage, ShowGrid
        can :manage, Star
        can :manage, StarVideo
        can :manage, User
        can :manage, UserVideo
        
        
      elsif user.member?#ordinary user
        can :read, Banner
        can :read, Blog
        can :create, Blog
        can :manage, Blog, :user_id => user.id
        can :create, Comment
        can :manage, Comment, :user_id => user.id 
        can :manage, Gift, :user_id => user.id  
        can :manage, Goals, :user_id => user.id  
        can :read, Illustration
        can :read, Page
        can :read, Star
        can :read, StarVideo
        can :read, User
        can :manage, User, :id => user.id
        can :manage, UserVideo, :id => user.id
        can :read, UserVideo
        can :manage, Visionboard
        can :read, Visionboard
       
      end
    # When not logged in
   else
     can :read, Banner
     can :read, Blog
     can :read, Comment
     can :read, Gift
     can :read, Illustration
     can :read, Page
    
     can :read, Star
     can :read, StarVideo
     can :read, User
     can :read, UserVideo
     can :read, Visionboard
     can :create, User# <----------- Uncomment this to alow users to signup by them self 
    end
  end
end
