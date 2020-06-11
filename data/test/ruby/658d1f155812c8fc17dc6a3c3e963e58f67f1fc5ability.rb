class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new 
    if user.has_role? :SuperAdmin
        can :manage, :all 
        
    elsif user.has_role? :Admin
        can :manage, Cliente
        can :manage, Orcamento
        can :manage, PedidoVenda
        can :manage, OrdemProducao
        can :manage, Layout
        
    elsif user.has_role? :Intermediario
        can :manage, Cliente
        can :manage, Orcamento
        can :manage, PedidoVenda
        can :manage, OrdemProducao
        can :manage, Layout
    else
      can :manage, OrdemProducao
      can :manage, Layout
    end  
      
  end

end