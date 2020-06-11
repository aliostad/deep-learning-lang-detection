# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    user_abilities(user) if user
  end

  def user_abilities(user)
    can :manage, Document, user: user

    can :manage, Scientist, document_ability(user)
    can :manage, MainModule, document_ability(user)

    can :manage, Topic, sub_module_ability(user)
    can :manage, SubModule, main_module_ability(user)
    can :manage, Lab, document_ability(user)
    can :manage, Practice, document_ability(user)
  end

  def document_ability(user)
    { document: { user: user } }
  end

  def main_module_ability(user)
    { main_module: document_ability(user) }
  end

  def sub_module_ability(user)
    { sub_module: main_module_ability(user) }
  end
end
