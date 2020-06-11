class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.super?
        can :manage, :all
      elsif user.admin?
        can :manage, Blog
        can :manage, Booking
        can :manage, Comment
        can :manage, Company
        can :manage, Gallery
        can :manage, Illustration
        can :manage, Meetingroom
        can :manage, CompanyThumb
        can :manage, Newspost
        can :manage, Photo
        can :manage, Page
        can :manage, User
        
      elsif user.member?#ordinary user 
        can :read, Blog
        can :create, Blog
        can :create, Booking
        can :manage, Booking, :user_id => user.id
        can :manage, Blog, :user_id => user.id
        can :create, Comment
        can :manage, Comment, :user_id => user.id  
        can :read, Company
        can :read, Gallery
        can :read, Illustration
        can :read, Meetingroom
        can :read, Newspost
        can :read, Page
        can :read, Photo
        can :read, User
        can :manage, User, :id => user.id
      end
    # When not logged in
    else
      can :read, Blog
      can :read, Booking
      can :read, Comment
      can :read, Company
      can :read, Gallery
      can :read, Illustration
      can :read, Meetingroom
      can :read, Newspost
      can :read, Page
      can :read, Photo
      can :read, User
     #can :create, User# <----------- Uncomment this to alow users to signup by them self 
    end
  end
end
