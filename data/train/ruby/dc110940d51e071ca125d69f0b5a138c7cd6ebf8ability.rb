class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    @user = User.find_by_id(user.id)
    unless @user.nil?
      if user.role.superadmin == true
        can :manage, User
        can [:show, :index], Role
        can :manage, Lotecanal
        can :manage, Existencium
        can :manage, Tarima
        can :manage, Corte
        can :manage, Articulo
        can :manage, Almacene
        can :manage, Familium
        #can :manage, SchemaMigration
        #can :manage, AccountType
        #can :manage, Account
        #can :manage, AddOn
        #can :manage, App
        #can :manage, CustomScaffold
        #can :manage, ColumnAttribute
        #        can [:show, :edit, :update, :index], User, :id => user.id
        #        can [:show, :index], Role, :id => user.role.id 
        #        can [:show, :index], Familium
        #        can [:show, :index], Tarima
        #        can [:show, :index], Corte
        #        can [:show, :index], Articulo
        #        can [:show, :index], Almacene
        #        can [:show, :index], Familium
        can [:show, :index], Existencium
      elsif user.role.administrator == true
        can [:show, :edit, :update, :index], User, :id => user.id
        #can [:show, :index], Role, :id => user.role.id 
        can [:show, :index], Familium
        can [:show, :index], Tarima
        can [:show, :index], Corte
        can [:show, :index], Articulo
        can [:show, :index], Almacene
        can [:show, :index], Familium
        can [:show, :index], Existencium
        can [:show, :index, :update], Lotecanal
      elsif user.role.guess == true
        can [:show, :edit, :update], User, :id => user.id
      end 
    end
  end
end
