class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.rolable_type == "Admin"
        can :manage, Credit, :client_id => user.rolable.organization.clients
        can :manage, Facilitator, :organization_id => user.rolable.organization_id
        can :manage, Invite, :organization_id => user.rolable.organization_id
        can :manage, Location, :organization_id => user.rolable.organization_id
        can :manage, Organization, :id => user.rolable.organization_id
        can :manage, Scrap, :client_id => user.rolable.organization.clients
        can :manage, User, :location_id => user.rolable.organization.locations
    elsif user.rolable_type == "Facilitator"
        can :manage, Credit, :client_id => user.rolable.organization.clients
        can :manage, Facilitator, :id => user.rolable.id
        can :read, Organization, :id => user.rolable.organization_id
        can :manage, Scrap, :client_id => user.rolable.organization.clients
        can :manage, User, :location_id => user.rolable.organization.locations
    elsif user.rolable_type == "Client"
        can :manage, User, rolable_id: user.rolable.id
    else
        can :read, Location
        can :create, Facilitator
        can :create, Admin
        can :create, Organization
    end
  end
end
