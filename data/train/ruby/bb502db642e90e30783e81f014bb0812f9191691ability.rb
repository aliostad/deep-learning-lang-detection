class Ability
  include CanCan::Ability

  def initialize(user)

   #Set default user if user not logged in
   user ||= User.new

   #Fetch abilities for each user role
   user.roles.each { |role| send(role, user) }

   #If no roles defined set default permissions
   default if user.roles.empty?
  end

  def default
    #Bnb
    can :read, Bnb
    can :nearby_bnbs, Bnb

    #Photo
    can :read, Photo
  end

  def admin(user)
    # Access everything
    can :manage, :all
  end


  def guest(user)

    #Bnb
    can :read, Bnb
    can :nearby_bnbs, Bnb

    #Booking
    can :manage, Booking, user_id: user.id
    cannot :destroy, Booking, user_id: user.id

    #Photo
    can :read, Photo

    #Rooms
    can :read, Room
    can :find_available, Room
  end

  def owner(user)
      #Subscription
      can :manage, Subscription, user_id: user.id

      #Bnb
      can :manage, Bnb, user_id: user.id

      #Rooms
      can :manage, Room

      #Bookings
      can :manage, Booking

      #Guest
      can :manage, Guest

      #Events
      can :manage, Event

      #LineItems
      can :manage, LineItem

      #Photos
      can :manage, Photo
  end
end
