class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.coach?
      can :manage, Coach, :id => user.role.id
      can :manage, Motivation, :coach_id => user.role.id
      can :manage, Player do |player|
        player.coach_ids.include?(user.role.id)
      end
      can :invite, Player
      can :manage, :dashboard
      can :manage, Assessment, :coach_id => user.role.id
      can :manage, Plan, :coach_id => user.role.id
      can :manage, Reward, :creator_id => user.role.id, :creator_type => 'Coach'
      can :manage, RewardImage, :creator_id => user.role.id, :creator_type => 'Coach'
      can :manage, Team, :coach_id => user.role.id
    end
  end
end
