class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    can :read, :all
    can :manage, Post, :user_id => user.id
    can :manage, Comment, :user_id => user.id 
    can :manage, Chunk, :user_id => user.id
    can :manage, Snack, :user_id => user.id
    can :update, ChunkWall, :user_id => user.id
    can :update, SnackWall, :user_id => user.id
    can :update, Blog, :user_id => user.id
    can :manage, SecretChunkWall, :user_id => user.id
    can :manage, SecretSnackWall, :user_id => user.id
    can :manage, SecretChunk, :user_id => user.id
    can :manage, SecretSnack, :user_id => user.id
  end
end
