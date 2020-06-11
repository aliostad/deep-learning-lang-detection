class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is_user?
      can :read, :except => UserChange
      can :look_user, :dashboard
      can :look, :report
      can :manage, Report.where(:user_id => user.id)
    end

    if user.is_teamleader?
      can :look_admin, :dashboard
      can :look, :teamleader_users
      can :manage, User.where(:department_id => user.department_id)
      can :look, :report
      can :manage, Report.where(:user_id => user.id)
      can :read, UserChange
    end

    if user.is_manager?
      can :look_admin, :dashboard
      can :manage, User
      can :manage, Department
      can :restore, :departments
      can :manage, Skill
      can :restore, :skills
      can :read, UserChange

    end

    can :manage, :all if user.is_admin?
  end
end