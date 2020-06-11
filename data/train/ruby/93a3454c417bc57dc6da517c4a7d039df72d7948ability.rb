class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is? :admin
      can :manage, :all
    elsif user.is? :site_manager
      can :manage, Member
      can :manage, Record
      can :manage, Repository
      can :manage, Source
    else
      # New User
      can :create, Member
      can [:read, :destroy], Member, user_id: user.id

      # Repository Editor
      unless user.repositories.empty?
        can :read, Member, active: true,
            repository: {id: user.active_repository_ids}
        can :read, Repository, id: user.active_repository_ids
        can :create, Record
        can :manage, Record, id: user.record_ids
      end

      # Repository Manager
      can [:update, :destroy], Repository,
          id: user.active_repository_ids,
          members: {user_id: user.id, manager: true}
      can :manage, Member,
          repository_id: user.manageable_repository_ids
    end
  end
end
