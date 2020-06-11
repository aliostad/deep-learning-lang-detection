class Ability
  include CanCan::Ability

  def initialize(user, current_company)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :company_admin
      can :manage, User, :companies => { :id => current_company.id }
      can :create, User
      can :manage, Currency, :company_id => current_company.id
      can :manage, BusinessProcess, :company_id => current_company.id
      can :manage, Step, :company_id => current_company.id
      can :manage, OutgoingArrow, :company_id => current_company.id
      can :manage, ProcessInstance, :company_id => current_company.id
      can :manage, Token, :company_id => current_company.id
      can :manage, Page
    elsif
     # hebelt für's erste Berechtigungen aus
      can :show, :all
      can :read, Page
    end
  end
end
