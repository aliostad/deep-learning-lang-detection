class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    # An admin may manage all and everything
    if user.role? :admin 
      can :manage, :all
    end

    # A reporter may manage news items and pages
    if user.role? :reporter
      can :manage, [Post, Page]
    end

    # A humanrelations may manage members, entities and something else not implemented
    if user.role? :humanrelations
      can :manage, [Entity, Member, Promotion, Role]
    end

    # A scheduler may fiddle with events
    if user.role? :scheduler
      can :manage, [Event, EventType]
    end

    # A member may manage his own availabilities
    can :manage, Availability do |availability|
      availability.member.user == user
    end

    # The magister and ensaiador may manage availabilities
    if user.role? :magister or user.role? :ensaiador
      can :manage, [Availability]
    end

    # A member may manage his own profile to a certain extent
    can :update, Member do |member|
      member.user == user
    end

    # Guest users may read some stuff
    can :read, [Post, Page, Member, Event]
  end
end
