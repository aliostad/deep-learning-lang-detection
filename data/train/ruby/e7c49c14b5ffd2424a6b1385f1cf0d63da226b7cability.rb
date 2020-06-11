class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin # admin user
      can :manage, ServicesController
      can :manage, ProjectsController
      can :manage, LocationsController
      can :manage, ClientsController
      can :manage, BrandAmbassadorsController
      can :manage, StatementsController
      can :manage, IsmpController
      can :manage, DefaultValuesController
      can :manage, ReportsController
      can :manage, UsersController
      can :manage, EmailTemplatesController
      can :manage, InvoicesController
      can :manage, TerritoriesController
      can :manage, OrdersController
      can :manage, CoordinatorController
      can :manage, AdditionalPersonnelsController
    elsif user.has_role? :ismp
      can :manage, ServicesController
      can :manage, ProjectsController
      can :manage, LocationsController
      can :manage, ClientsController
      can :manage, BrandAmbassadorsController
      can :manage, StatementsController
      can :manage, ReportsController
      can :manage, UsersController
      can :manage, InvoicesController
      can :manage, OrdersController
    elsif user.has_role? :ba
      can :manage, UsersController
      can :manage, ReportsController
      can :manage, MyStatementsController
    elsif user.has_role? :client
      can :manage, ReportsController
      can :manage, ClientsController
    elsif user.has_role? :coordinator
      can :manage, ServicesController
      can :manage, LocationsController
      can :manage, ClientsController
      can :manage, BrandAmbassadorsController
      can :manage, ReportsController      
    end
    can :manage, AvailableDatesController if user.has_role? :ba
    can :manage, AssignmentsController if user.has_role? :ba
  end
end
