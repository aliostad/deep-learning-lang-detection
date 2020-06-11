#
# Authorization model for the system.  leverages the cancan gem
# There are four roles, everyone, invoice, admin and superadmin
#
class Ability
  include CanCan::Ability

  def initialize(user)  
    if user.ability_superadmin
      # super user can only manage the maintenance areas of the system
      # super usr is a generic id, so we dont want it to modify group/provider/patient areas
      super_admin_rights
    elsif user.ability_admin
      # can manage everything, including invoicing
      can :manage, :all
    else
      set_everyone_rights(user)       
    end
  end


  #grants the general rights to the system
  def set_everyone_rights(user)
    can :manage, :all    
    cannot :manage, AccidentType
    cannot :manage, CodesPos       
    cannot :manage, EdiVendor
    cannot :manage, InsuranceType
    cannot :manage, InsuredType    
    cannot :manage, OfficeType
    cannot :manage, ReferredType
    cannot :manage, SystemInfo
    cannot :manage, User
    can :password, User
    can :update_password, User
    # if the user has the ability to invoice, then dont take away the right
    cannot :manage, Invoice if !user.ability_invoice    
  end
  
    
  # super admin should have rights to the maintenance areas of the system  
  # amount of areas a super user cannot manage is greater than the manage
  # so it is easier to take away all rights nd add the specific areas
  def super_admin_rights
      # take away all rights and add just the maintenance and system areas 
      cannot :manage, :all
      can :manage, AccidentType
      can :manage, CodesCpt
      can :manage, CodesDsm
      can :manage, CodesIcd9
      can :manage, CodesModifier
      can :manage, CodesPos  
      can :manage, EdiVendor
      can :manage, :home
      can :manage, InsuranceCompany
      can :manage, InsuranceType
      can :manage, InsuredType
      can :manage, :maint
      can :manage, OfficeType
      can :manage, ReferredType
      can :manage, SystemInfo
      can :manage, User
  end

end
