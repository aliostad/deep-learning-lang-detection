class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    if user.caregiver.present? && user.caregiver.is_caregiver?
      caregivers_abilities
    end
  end

  def caregivers_abilities
    can :manage, Theme
    can :manage, Context
    can :manage, Group
    can :manage, Story
    can :manage, StoryFragment
    can :manage, Caregiver
    can :manage, Guest
    can :manage, Attachment
    can :manage, Comment
    can :manage, Session
    can :manage, Slot
    can :manage, Block
    can :manage, Multimedia
    can :manage, Question
  end
end
