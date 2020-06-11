class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user.has_role?(:account_admin) || user.has_role?(:account_owner)
      can :manage, :all
    else
      can :read, [Property, Campaign, Content, Contact, Person, Organization]
      can :update, User, :id => user.id
    end
    
    can :manage, Campaign                         if user.has_role?(:campaign_manager)
    can :manage, [Contact, Person, Organization]  if user.has_role?(:crm_manager)
    can :manage, Content                          if user.has_role?(:designer)
  end

  
  alias :permitted_to? :can?
end