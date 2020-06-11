class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    #--------------------------------------------
    #case user.uid
    #  when "507245646"
    #    can :manage, :all
    #    #can :access, :rails_admin # grant access to rails_admin
    #  else
    #    cannot :manage, :all
    #    #cannot :access, :rails_admin
    #end
    #--------------------------------------------
    #puts user.admin
    if user.is_admin?
      can :manage, :all
    else
      cannot :manage, :all
    end
    end


  end
