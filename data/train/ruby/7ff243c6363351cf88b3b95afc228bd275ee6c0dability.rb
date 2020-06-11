class Ability
  include CanCan::Ability

  def initialize(user)
    can [:new, :create], User
    if user.present?
      can :manage, User, id: user.id
      can [:new, :create, :use_skill], Unit
      can [:new, :create], Combat
      can [:new, :create, :show], CombatAction
      can :manage, Unit, id: user.units.pluck(:id)
      can :manage, UnitImage, unit_id: user.units.pluck(:id)
      can :manage, Combat, id: user.combats.pluck(:id)
      can :manage, CombatAction, unit_id: user.units.pluck(:id)
    end
  end
end
