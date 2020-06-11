class Ability
  include CanCan::Ability

  def initialize(operador)
    if operador
      can :manage, :all
    else
      cannot :manage, :all
      can :manage, Application
      can :manage, Session
      can [:read, :mandato, :na_luta, :biografia, :agenda], Noticia
      can :read, Video
      can [:create, :cancelar_newsletter, :destroy, :enviar_contato, :contato, :indiquenos, :enviar_indiquenos, :resultado_indiquenos], Newsletter
      can :read, Galeria
      can :read, Foto
      can :login, Operador
    end
  end
end
