class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "admin"
      can :manage,                    User
      can :manage,                    Score
      can :manage,                    Question
      can :manage,                    Option
      can :manage,                    ScoreLine
      can :manage,                    Product
      can :manage,                    School
      can :manage,                    Comment
      can :manage,                    Order
      can :manage,                    Notice
    else
      can [:create],                  User
      can [:show, :update, :destroy], User, :id => user.id
      can [:updateavatar],            User, :id => user.id
      can [:update_cell],             User
      can [:send_code],               User
      can [:read, :create],           Score, :user_id => user.id
      can [:topten],                  Score
      can [:read],                    Question
      can [:question_group],          Question
      can [:read],                    Option
      can [:read, :create],           ScoreLine, :user_id => user.id
      can [:read],                    Product
      can [:read],                    School
      can [:read, :create],           Comment
      can [:destroy],                 Comment, :user_id => user.id
      can [:read],                    Order, :user_id => user.id
      can [:reset_password],          User
      can [:update_password],         User
      can [:read],                    Notice
    end
  end
end
