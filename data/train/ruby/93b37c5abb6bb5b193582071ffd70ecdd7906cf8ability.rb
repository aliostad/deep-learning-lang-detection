class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.super?
        can :manage, :all
      elsif user.admin?
        can :manage, FlashFile
        can :manage, User
        can :manage, TextContent
        can :manage, GalleryImage
        can :manage, CaseStudy
        can :manage, CaseImage
        
        # add application-specific changes below
        
        
      elsif user.member?
        # Ordinary user
        can :manage, User, :id => user.id # <--- Allow user to manage self
        can :read, FlashFile
        can :read, TextContent
        can :read, GalleryImage
        can :read, CaseStudy
        can :read, CaseImage
        # add application-specific changes below
        
        
      end
    else
      # When not logged in
      #can :create, User # <----------- Uncomment this to alow users to signup by them self
      can :read, FlashFile
      can :read, TextContent
      can :read, GalleryImage
      can :read, CaseStudy
      can :read, CaseImage
      # add application-specific changes below
      
      
    end
  end
end
