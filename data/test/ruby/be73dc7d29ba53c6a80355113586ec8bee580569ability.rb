class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Guest.new
    Rails.logger.info "USER #{user.inspect}"
    if user.is_a?(Admin)
      Rails.logger.debug "ADMIN #{user.email}"
      can :manage, User
      can :manage, Project
      can :manage, Phase
      can :manage, Idea
      can :manage, Resource
      can :manage, Comment
    elsif user.is_a?(Member)
      Rails.logger.debug "MEMBER #{user.email}"
      can :create, Project
      can :read, Project
      can :read, Phase
      can :create, Idea
      can :manage, Idea do |u|
        u == user
      end
      can :create, Resource
      can :manage, Resource do |u|
        u == user
      end
      can :manage, Comment do |u|
        u == user
      end
    else
      Rails.logger.debug "GUEST #{user.email}"
      can :read, User
      can :read, Project
      can :read, Phase
      can :read, Idea
      can :read, Resource
      can :read, Comment
    end
  end
end
