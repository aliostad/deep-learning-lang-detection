class Ability
  include CanCan::Ability
 
  def initialize(user)
      puts "#{'*'*80}\nAllowing to manage all\n#{'*'*80}"
    user ||= AdminUser.new # guest user (not logged in)
    if user.role? :superadmin
        can :manage, :all
    end
    if user.role? :advertiser
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, Slam
    else
      can [:manage], UserGroup, user_id: user.id
      can [:manage], Medium, user_id: user.id
      can [:manage], Slam, medium_first: {user_id: user.id}
      can [:manage], Member, user_group: {user_id: user.id}
      can [:destroy], Member, user_id: user.id
      can [:manage], UserVote
      can [:manage], Follower
      
      can :destroy, Comment, user_id: user.id
      can :destroy, Comment, commentable: {user_id: user.id}
      #can :manage, Member
      can :read, :all
      can :manage, User, id: user.id
      can [:follow, :unfollow], User

    end
  end
end
