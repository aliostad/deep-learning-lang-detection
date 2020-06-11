class Ability
  include CanCan::Ability

  def initialize(user)

    #user.groups[0].rules[2]
    if user != nil
      user.groups.each do |grupo|
        #Verifica a permissao nos grupos
        #byebug
        if grupo[:nome] == "VENDA_PLANO"
            can :manage, Tipovenda
            can :manage, Tabelaplano
            can :manage, Formapagamento
            can :manage, Vendaplano
            can :manage, Aluno
        elsif grupo[:nome] == "SYSTEM_ADMIN"
            can :manage, :all
        elsif grupo[:nome] == "SUPER_USER"
            can :manage, :all
        elsif grupo[:nome] == "TREINO"
            can :manage, Aluno
            can :manage, Atividade
            can :manage, Treino
            can :manage, Adaptacao
            can :manage, Musculo
        end
      end
    else
      can :manage, :all
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
