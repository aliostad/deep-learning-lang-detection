class Ability
  include CanCan::Ability

  def initialize( user ) 
    user ||= User.new                          # guest user 

    if user.role? :admin 
      can :manage, :all 
    elsif user.role? :diretor
      can :manage, Atendimento
      can :manage, Cliente
      can :manage, User
      can :manage, Estagiario
    elsif user.role? :estagiário
      can :manage, Atendimento
      can :manage, Cliente
      can :edit,   Estagiario
    elsif user.role? :calouro
      can :manage, Cliente
      can :manage, Atendimento
      can :edit,   Calouro
    elsif user.role? :vareiro
      can :edit, Vareiro
    end 
  end 
end
