class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.role? :admin
      can :read, :all
      can :manage, :all
    elsif user.role? :dap
      can :read, :all
      can :manage, :all
    elsif user.role? :licitacao
      can :read, :all
      can :manage, Uasg
      can :manage, Supplier
      can :manage, RequestLog
    elsif user.role? :almoxarifado
      can :read, :all
      can :create, StockroomItem
      can :create, StockroomMovimentation
    else #solicitante
      can :read, :all
    end
  end
end
