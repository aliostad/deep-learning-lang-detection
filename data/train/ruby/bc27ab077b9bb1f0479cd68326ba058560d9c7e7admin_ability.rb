class AdminAbility
  include CanCan::Ability

  def initialize( usuario )
    if usuario.role? "admin"
      can :access, :rails_admin # panel de administracion
      can :dashboard # panel de administracion
      can :manage, :all
    elsif usuario.role? "employee"
      can :access, :rails_admin # panel de administracion
      can :dashboard # panel de administracion
      can :manage, Configuration
      can :manage, Matriculacion
      can :manage, Justificante
      can :manage, Mandato
      can :manage, Informe
      can :manage, ZipMatricula
    elsif usuario.role? "remarketing"
      can :access, :rails_admin # panel de administracion
      can :dashboard # panel de administracion
      can :manage, XmlVehicle
      can :manage, StockVehicle
    end
    cannot :history, :all
  end
end