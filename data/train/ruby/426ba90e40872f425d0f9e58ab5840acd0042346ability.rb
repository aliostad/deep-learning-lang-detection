class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new
    
    if user.role? :admin
      can :manage, :all

    elsif user.role? :moderator
      can :manage, User
      can :manage, IscOrder
      can :manage, BankTransaction
      can :manage, Supplier
      can :manage, Audit
      can :manage, Product
      can :manage, Site
      can :manage, Email

    elsif user.role? :services
      can :read, Product
      can :manage, IscOrder
      can :read, Supplier
      can :read, Site
      can :create, Product
      can :update, Product
      can :manage, BankTransaction
      can :manage, Email
    
    elsif user.role? :finance
      can :manage, BankTransaction
      can :manage, IscOrder
      can :read, Site
      can :update, Site
      can :create, Site
      can :create, User
      can :update, User
      can :read, User
      can :manage, Audit
    
    elsif user.role? :moderator2
      can :create, Site
      can :update, Site
      can :read, Site
      can :create, User
      can :read, User
      can :update, User

    elsif user.role? :external
      can :create, BankTransaction 
      can :read, BankTransaction
      can :update, BankTransaction
      can :read, IscOrder
      
    else
      #none
    end
  end
  
end
