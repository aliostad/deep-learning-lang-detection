class Ability
  include CanCan::Ability

  def initialize(manager)
    manager ||= Manager.new
    if manager.administer?
      role_administer
    elsif manager.charge?
      role_charge
    elsif manager.teacher?
      role_teacher
    else
      can :manage, :all
    end
  end

  #管理员对所有模型有操作权限
  def role_administer
    can :manage, :all
  end

  #负责人对所负责课程有操作权限
  def role_charge
    can :manage, Course
    can :manage, SubCourse
    can :manage, Question
  end

  #课程老师对所教课程有查看权限
  def role_teacher
    can :read, Course
    can :read, SubCourse
    can :read, Question
  end
end
