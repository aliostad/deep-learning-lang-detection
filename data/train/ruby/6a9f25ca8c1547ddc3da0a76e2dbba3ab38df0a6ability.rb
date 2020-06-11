class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    
    cannot :manage, :all

    
    can :read, :all
    can :create, User

    if user.role? :admin

      can :manage, :all

    elsif user.role?(:member) && user.persisted? 

      
      cannot :manage, Forum
      can :read, Forum

      
      can [:create, :read], Topic
      can :update, Topic do |t|
        t.user_id == user.id
      end
      cannot :destroy, Topic

      
      cannot :manage, Post
      can :read, Post
      can :create, Post
      can :manage, Post do |p|
        p.user_id == user.id
      end

      
      cannot :manage, User
      can :read, User
      can :manage, User do |u|
        u.id == user.id
      end

    end

  end
end 