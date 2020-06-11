class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    # Normal Users
    can :read, [Board, Post, Tripcode]
    can :create, [User, Report, Post]
    can :search, Board
    # Users can delete a post if they have they have created the post or if they moderate the board.
    # Take a look at posts#destroy for an explanation.

    if @user.janitor?
      can :destroy, Post
      can :manage, Report
    end

    if @user.moderator?
      can :manage, Post
      can :manage, Report
      can :manage, Suspension
    end

    if @user.administrator?
      can :manage, Post
      can :manage, Report
      can :manage, Suspension
      can :manage, Board
      can :manage, User
    end

    can(:manage, :all) if @user.operator?
  end
end
