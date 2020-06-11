class Ability
  include CanCan::Ability
 # aca defino permisos para usuario
  def initialize(user)
    #user ||= User.new # guest user (not logged in)
    if user.is_a?(Producer)
      #productora
      #can :manage, Ticket
      #can :read, Event
      can :manage, City
      #can :geo, City
      can :list, Event
      can :img, Event
      can :show, Event
      can :read, Country
      can :read, Region
      can :manage, Producer
      can :manage, Event
      can :manage, EventType
      #can :manage, Purchase
      #can :manage, Booking
      cannot :manage, User
    elsif user.is_a?(User)
      #usuario
      if user.has_role? :normal
        #usuario normal
        #can :read, Event
        can :read, Event
        can :list, Event
        can :show, Event
        can :img, Event
        can :read, City
        can :geo, City
        can :read, Country
        can :read, Region
        can :manage, User
        can :read, Event  #consultar evento
        #can :create, Purchase #crear venta
        cannot :destroy, User #porciacaso
        #can :manage, Comment #comentarios (create,read,update-depende del controlador-)
        #can :manage, Invitate #invitaciones
        #can :create, Booking #reservas
        #can :manage, Friendship#CRUD amistades (depende del controlador)
        cannot :create, Producer 
      elsif user.has_role? :moderador
        #usuario moderador
        can :manage, Event
        can :read, City
        can :geo, City
        can :read, Country
        can :read, Region
        can :manage, Event #CRUD evento
        can :manage, User
        #can :create, Purchase #crear venta
        #can :manage, Comment #comentarios (create,read,update-depende del controlador-)
        #can :manage, Invitate #invitaciones
        #can :create, Booking #reservas
        #can :manage, Friendship#CRUD amistades (depende del controlador)
      end
    else
      # invitado xd
      can :manage, EventType
      can :create, Event
      #can :manage, Event# se requiere ingresar como producer
      can :list, Event
      can :img, Event
      can :show, Event
      can :read, City
      can :geo, City
      can :read, Country
      can :read, Region
      #permisos de acciones de  usuario
      can :create, User
      can :check_username, User
      can :check_run, User    
      can :check_email, User
      #permisos de acciones de  producer
      can :check_username, Producer
      can :check_run, Producer
      can :check_email, Producer
      can :create, Producer
    end
  end
end