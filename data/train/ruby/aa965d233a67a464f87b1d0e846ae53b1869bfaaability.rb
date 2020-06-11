class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, Teacher
      can :manage, User
      can :manage, Faculty 
      can :manage, Work
      #info and backup isn't an model
    
    elsif user.has_role? :faculty_admin
      can :manage, Teacher
      can :manage, User
      can :manage, Course, faculty: { head_id: user.id }
      can :manage, Department, faculty: { head_id: user.id }
      can :manage, Group, department: { faculty: { head_id: user.id } }
    
    elsif user.has_role? :student
      can :manage, Work, student_id: user.id
      can :manage, User, id: user.id 
      can :manage, Student, user_id: user.id
    elsif user.has_role? :teacher
      can :manage, Student, group: { head_id: user.id }
      can :manage, User, id: user.id
      can :manage, Teacher, user_id: user.id 
      can :manage, Work, student: { group: { department: { faculty: { id: user.teacher.department.faculty.id } }}}
    elsif user.has_role? :guest
      can :read, :all
      can :manage, User, id: user.id
    else
      can :read, :all 
    end
  end

end
