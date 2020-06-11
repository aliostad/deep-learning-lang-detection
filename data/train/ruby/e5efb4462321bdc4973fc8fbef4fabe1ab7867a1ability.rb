class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.role? :super_admin
      can :manage, :all
    elsif user.role? :organization_admin
      can :manage, [Organization, Location]
    elsif user.role? :location_admin
      can :read, Organization
      can :manage, Location do |location|
        location.try(:owner) == user
      end
    elsif user.role? :venue_admin
      can :read, [Organization, Location]
      # manage products, assets he owns
      can :manage, Venue do |venue|
        venue.try(:owner) == user
      end
    end
  end
end