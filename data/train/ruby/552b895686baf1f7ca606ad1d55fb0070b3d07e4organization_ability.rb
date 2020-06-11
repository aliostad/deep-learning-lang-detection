class OrganizationAbility
  include CanCan::Ability

  def initialize(organization)
    organization.kits.each do |kit|
      kit.abilities.arity < 1 ? instance_eval(&kit.abilities) : kit.abilities.call(self)
    end

    can :manage, Event, :organization_id => organization.id
    can :manage, Show, :organization_id => organization.id
    can :manage, Chart, :organization_id => organization.id
    can :manage, Ticket, :organization_id => organization.id
    can :manage, Person, :organization_id => organization.id
    can :manage, Segment, :organization_id => organization.id
    can :manage, Order, :organization_id => organization.id
    can :manage, Household, :organization_id => organization.id

    can :manage, Organization, :id => organization.id
  end
end
