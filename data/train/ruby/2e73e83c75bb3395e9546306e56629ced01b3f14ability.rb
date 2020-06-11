class Ability
  include CanCan::Ability

  def initialize(user)

      # user ||= User.new # guest user (not logged in)
      unless user.nil?
        if user.has_role? :god
          can :manage, :all
        elsif user.has_role? :staff
          cannot :mange, Fundertype
          can :manage, [Space, Applicationcomment, Performanceapplication, Performanceapplicationcomment, Spacecomment, Application, Pressrelease, Presslink]
          can :manage, Page, :subsites => {:name => 'supermarket2014'}
          can :manage, Post
          can :manage, Video
          cannot :manage, [Year, User, Subsite, Frontcarousel]
          can :manage, User, :id => user.id
          can :read, Subsite, :name => 'supermarket2014'
        elsif user.has_role? :aim_staff
          can :manage, Space
          can :manage, Exhibitionspacetype
          can :manage, Activity
          can :manage, Organisationtype
          can :manage, Spacecomment
          can :manage, Businesstype                              
          can :manage, User, :id => user.id
          can :read, Subsite, :name => 'aim'
          can :manage, Page, :subsites => {:name => 'aim'}        
        elsif user.has_role? :videoproducer
          can :manage, Video
          cannot :read, Spacecomment
          cannot :read, Applicationcomment
          cannot :read, Attendee
        elsif user.has_role? :volunteer
          can :manage, Attendee
        elsif user.has_role? :supermarket_exhibitor
          cannot :manage, Page
          cannot :read, Spacecomment
          cannot :read, Applicationcomment          
          can :manage, Space, :id => Space.with_role(:supermarket_exhibitor, user).map(&:id)
        else
          cannot :manage, [Page, Post]
          can :read, :all
          cannot :read, Applicationcomment
          cannot :read, Spacecomment
        end
      end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
