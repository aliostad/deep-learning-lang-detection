class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    if user.role? :admin
      can :manage, :all
    elsif user.role? :secretary
      can :manage, [Patient, PlasticSurgeryPatient, DermatologyPatient, OccupationalTherapyPatient]
    elsif user.role? :plastic_surgery_doctor
      can :manage, [PlasticSurgeryPatient]
    elsif user.role? :dermatology_doctor
      can :manage, [DermatologyPatient]
    elsif user.role? :occupational_therapy_doctor
      can :manage, [OccupationalTherapyPatient]
    end
  end
  
end
