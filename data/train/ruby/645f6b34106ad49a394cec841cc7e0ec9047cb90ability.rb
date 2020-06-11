require 'invitational/cancan'

class Ability
  include CanCan::Ability
  include Invitational::CanCan::Ability

  attr_reader :role_mappings, :user

  def initialize(user)

    @role_mappings = {}
    @user = user

    can :manage, Entity, roles: [:admin]
    can :read, Entity, roles: [:user]

    can :read, Child

    can :manage, Child, roles: [:admin, attribute_roles(:entity, [:admin, :user]) ]
    can :manage, Child, roles: [attribute_roles([:entity, :grandparent], [:admin]) ]

    can :manage, OtherEntity, roles: [:uberadmin]

    can :manage, SystemThing, roles: [system_roles(:employer)]
  end

end

