class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new # guest user (not logged in)
    if user.role.name == "Admin"
      can :manage, :all
    elsif user.role.name == "student"
      #can :manage, @forum
=begin
      can :read, @forums
      can :read, @topic
      can :read, @mark

      cannot :manage, @subject
      cannot :manage, @chapter
      cannot :manage, @topic
      cannot :manage, @question
      cannot :manage, @role
      cannot :manage, @admin
      cannot :manage, @teacher
      cannot :manage, @student
      cannot :manage, @user
      cannot :manage, @batch
      cannot :manage, @batchtest
      cannot :manage, @batchstudent
      cannot :manage, @jktest
      cannot :manage, @testquestion
      
      
      cannot :create, @forum
      cannot :update, @forum
      cannot :destroy, @forum

      can :create, @testattempt
      cannot :destroy, @testattempt
      
      cannot :read, @solvedtest
      can :create, @solvedtest
      cannot :destroy, @solvedtest
      
      
      can :create, @mark
      cannot :update, @mark
      cannot :destroy, @mark
      

      can :create, @topic
      cannot :update, @topic
      cannot :destroy, @topic
=end

    elsif user.role.name == "teacher"
      #can :manage, @home
      can :manage, @profile
      
      can :read, @subject
      cannot :create, @subject
      cannot :update, @subject
      cannot :destroy, @subject

      can :read, @chapter
      cannot :create, @chapter
      cannot :update, @chapter
      cannot :destroy, @chapter
      

      can :read, @topic
      cannot :create, @topic
      cannot :update, @topic
      cannot :destroy, @topic

      can :manage, @question

      can :read, @student
      can :create, @student
      can :update, @student
      cannot :destroy, @student
      
      cannot :manage, @role
      cannot :manage, @admin
      cannot :manage, @teacher
      can :manage, @user
      can :manage, @batch
      can :manage, @batchtest
      can :manage, @batchstudent
      can :manage, @report
      can :manage, @jktest
      can :manage, @testquestion
      
      can :read, @forum
      can :create, @forum
      can :update, @forum
      can :destroy, @forum

      cannot :create, @testattempt
      can :destroy, @testattempt
      
      can :read, @solvedtest
      cannot :create, @solvedtest
      can :destroy, @solvedtest
      
      can :read, @mark
      cannot :create, @mark
      cannot :update, @mark
      can :destroy, @mark
      
      can :read, @topic
      can :create, @topic
      cannot :update, @topic
      can :destroy, @topic
      
      cannot :manage, @todays_test

    end 
  end
end
