class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user.instance_of? User
      
      #usuario loggeado
      ## TODO revisar que lleva permisos realmente de manage
      can :pico_placa, :acc
      can :manage, Agreement 
      can :manage, :carpool
      can :manage, :confirmation
      can :manage, InsuranceLead
      can :manage, InsurancePrice
      can :manage, Lead
      can :manage, Location
      can :manage, :password
      can :manage, Perk
      can :manage, ProcessLead
      can :manage, :registration
      can :manage, Ride
      can :manage, RoadsideAssistance
      can :manage, :session
      can :manage, User
      can :manage, Vehicle
    else
      
      user = User.new # guest user
      
      # Cualquiera no loggeado
      can :pico_placa, :acc
      can [:index, :active], Agreement #quitar el de active, es público para admins 
      can :create, InsuranceLead
      can [:read, :table], InsurancePrice #sólo lectura
      can :create, Lead
      can  [:index, :active], Location #quitar el de active, es público para admins
      can [:create, :update], :password #agregar update, es público para admins
      can [:index, :active], Perk #quitar active
      can :create, ProcessLead
      can :create, :registration
      can [:create, :solved], RoadsideAssistance #quitar el solved, es público para admins
      can [:login, :logout], :session
      can :active, User #agregar show para consultar su perfil, quitar, es para el admin
      can :manage, :confirmation
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
