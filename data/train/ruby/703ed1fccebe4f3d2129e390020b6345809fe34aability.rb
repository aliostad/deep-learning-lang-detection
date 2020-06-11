class Ability
  include CanCan::Ability

  def initialize(user)   
    if user.nil?
      can :read, :all
      can :create, UserSession
      #puts "Usuario Nulo"
    else
      can :read, :all
      can :for_countyid, Town
      can :for_directionid, Department
      can :for_activitytypeid, Activity
      can :for_departmentid, Activity
      can :destroy, UserSession 
      can :change_password, User
      can :download_manual, Home
      can :program_search, Program
      can :program_report, Program
      can :program_report_all, Program
      can :program_report, Report
      can :program_report_all, Report
      can :program_report_county, Report
      can :report_town_act, Report
      can :for_programid, Activity

      can :autocomplete_person_name, Affiliate
      can :autocomplete_person_last_name, Affiliate
      can :autocomplete_person_second_last_name, Affiliate
      can :autocomplete_institution_name, Affiliate
      can :for_program_id, Affiliate

      can :for_benefitcategoryid, Office
      can :for_program_id, Office
      can :autocomplete_person_last_name, Office
      can :autocomplete_institution_name, Office

      can :autocomplete_last_name, Family
      can :autocomplete_name, Family
      can :autocomplete_second_last_name, Family

      can :for_category_id, Benefit
      can :show_benefit, Benefit
      # Basically if/elsif/else (notice there's nothing
      # after the word "case"):
           
      case user.roles.to_s 
      when "admin" then
        #10.times { print "Hello admin" }
        can :manage, :all
      when "oficios" then
        can :manage, Office
        can :manage, OfficeAllocation
        can :manage, OfficeBenefitRequested
        can :manage, OfficeRecord
      when "asocial" then
        can :manage, Institution
        can :manage, OneRegInstitution
        can :manage, SchoolAge
        can :manage, AgePopulation
        can :manage, Person
        can :manage, Family
        can :manage, Benefit
        can :manage, Affiliate
        can :manage, SocioeconomicStudy
      when "planeacion" then
         #10.times { print "Hello planeacion" }
        can :manage, Department
        can :manage, Direction
        can :manage, User
        can :manage, PriorityProgram
        can :manage, PriorityProgramGoal
        can :manage, PriorityProgramStrategy
        can :manage, PriorityProgramActionLine
        can :manage, Ped
        can :manage, PedSubTheme
        can :manage, PedGoal
        can :manage, PedStrategy
        can :manage, PedActionLine
        can :manage, Program
        can :manage, CriticalSuccessFactor
        can :manage, CriticalSuccessFactorType
        can :manage, ActivityType
        can :create, Activity
        can :update, Activity do |acti|
          acti.try(:user) == user 
        end  
        can :destroy, Activity do |acti|
          acti.try(:user) == user 
        end
        when "user" then
          can :create, Worth
          can :create, Affiliate
          can :update, Affiliate
          can :update, PeriodTimeDeliver
          can :create, Office
          can :create, Benefit
          can :destroy, Benefit
          can :create, Activity
          can :update, Activity do |acti|
            acti.try(:user) == user
          end
          can :destroy, Activity do |acti|
            acti.try(:user) == user
          end
      end

      # If you assigned 'variable =' before the case,
      # the variable now has the value of the
      # last-executed statement--or nil if there was
      # no match.  variable=if/elsif/else does this too.      
  
    end
  end
end