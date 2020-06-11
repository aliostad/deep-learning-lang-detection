class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is_role?(:administrador)
      can :manage, :all
    elsif user.is_role?(:funcionario)        
      can :manage, Category
      can :manage, Produto 
      can :manage, Cliente
      can :manage, Chamado
      can :manage, Servico
      can :manage, Funcionario
      can :manage, Compromisso
    elsif user.is_role?(:cliente)        
      can :manage, Category
      can :manage, Produto, :user_id => user.id
      can :manage, Cliente, :user_id => user.id
      can :manage, Chamado, :user_id => user.id
      can :read, User
      # can :edit, Produto do |produto|
      #   produto && produto.user == user
      # end
      can :update, User do |u|
        u == user
      end      
    end
  end

end
