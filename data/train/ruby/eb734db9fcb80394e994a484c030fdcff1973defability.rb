class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    can :read, :all # todos pueden ver todo.

    user.roles.each do |r|
      self.send(r.name.downcase)
    end

  end

  #el usuario admin tiene todos los privilegios
  def admin
    can :manage, :all
  end

  #privilegio sobre las reservas.
  def reservas
    can :create, Reserva
    can :update, Reserva
  end

  #puede dar altas y bajas de pagos depostios y cambios
  def pagos
    can :manage, Deposito
  end

  def tablas
    can :manage, Operadora
    can :manage, Agency
    can :manage, Programa
    can :manage, Thabitacion
    can :manage, Cotizacion
    can :manage, Pasajero
  end
end

