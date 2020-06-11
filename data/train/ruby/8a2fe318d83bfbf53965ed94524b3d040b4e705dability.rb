class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can [:manage], user do |u|
        user.id == u.id
      end
      can [:manage], Tree do |t|
        t.user_id == user.id
      end
      can [:manage], AccountSettings do |a|
        a.user_id == user.id
      end
      can [:manage], FirelistItem do |i|
        i.user_id == user.id
      end
      can [:manage], Task do |t|
        t.user_id == user.id
      end
      can [:manage], TaskQueue do |q|
        UserQueueAssignment.find_by_user_id(user.id).task_queue.id == q.id
      end
      can [:manage], Node do |n|
        n.user_id == user.id
      end
    end

  end
end
