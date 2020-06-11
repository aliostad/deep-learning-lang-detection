class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
     user ||= User.new # guest user (not logged in)
      if user.has_role? :dios
        can :manage, :dios
        can :manage, User
        can :manage, Cliente
        can :manage, Region
      elsif user.has_role? :admin
        if user.has_role? :copropietario ## Validando si es admin y copropietario a la vez.
          can :manage, Comunidad
          can :manage, Admin
        end
         can :manage, Admin
         can :manage, User
         can :manage, Comunidad
         can :manage, EspacioComun
         can :manage, Sector
         can :manage, TipoUnidad
         can :manage, Unidad
         can :manage, UserUnidad
         can :manage, Empleado
         can :manage, Remuneracion
      elsif user.has_role? :copropietario
         can :manage, Comunidad #aca tengo que poner a los modelos a los cuales tendra acceso.
      elsif user.has_role? :arrendatario
         can :manage, Comunidad
      elsif user.has_role? :copropietario_residente
         can :manage, Comunidad
      elsif user.has_role? :comite
         can :manage, Comunidad
      end
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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end