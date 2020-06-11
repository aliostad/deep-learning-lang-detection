class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :access, :rails_admin
      can :dashboard
      
      if user.has_role?(:client_admin)
        can :manage, User, :company_id => user.company_id
        can :manage, Truck, :company_id => user.company_id
        can :manage, GpsUnit, :company_id => user.company_id
        can :read, Company, :id => user.company_id
        can :manage, Route, :company_id => user.company_id
        can :manage, Checkpoint, Checkpoint.from_company(user.company_id) do |c|
          true
        end
      elsif user.has_role?(:client_owner)
        can :manage, User, :company_id => user.company_id
        can :manage, Truck, :company_id => user.company_id
        can :manage, GpsUnit, :company_id => user.company_id
        can :read, Company, :id => user.company_id
        can :manage, Route, :company_id => user.company_id
        can :manage, Checkpoint, Checkpoint.from_company(user.company_id) do |c|
          true
        end
      elsif user.has_role?(:superuser)
        can :manage, [User,
                      Company,
                      Truck,
                      Instant,
                      GpsUnit,
                      Route,
                      Checkpoint]
      end
    end
  end
end