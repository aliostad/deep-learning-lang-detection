class Ability
  include CanCan::Ability
  
  def initialize(user)

    if user && user.es?(Nivel::OPERADOR_ADMINISTRADOR)
      can :manage, :all
    else
      # por defecto
      can :manage, InformacionCrediticiaController
      can :manage, DashboardController
      can :manage, ConstruccionController
    end

    if user && user.es?(Nivel::OPERADOR)
      # Habilidades específicas de OPERADOR
      can :manage, AsistenciaTelefonicaController
    elsif user && user.es?(Nivel::CONSULTOR)
      # Habilidades específicas de CONSULTOR
    elsif user && user.es?(Nivel::CONSULTOR_ADMINISTRADOR)
      # Habilidades específicas de CONSULTOR_ADMINISTRADOR
      can :manage, ImportarRegistrosController
      can :manage, ImportarArchivosController
      can :manage, DetalleFacturacionController
      can :manage, EstadoCuentaController
    end


  end
end