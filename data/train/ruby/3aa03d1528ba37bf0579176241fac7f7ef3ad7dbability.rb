class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    @user = User.find_by_id(user.id)
    unless @user.blank?
      if @user.role.super_admin == true
        can :manage, :all
      elsif @user.role.company_admin == true
        can [:show, :edit, :update], Company, :id => @user.company_id        
        can :manage, Branch, :company_id => @user.company_id
        can :manage, Storage, :company_id => @user.company_id 
        can :manage, User, :company_id => @user.company_id
        can :manage, Truck, :company_id => @user.company_id    
        can :manage, Cellphone, :company_id => @user.company_id  
        can :manage, Message, :company_id => @user.company_id           
        can [:new, :create, :show], Comment, :user_id  => @user.id
        can :manage, Driver, :company_id => @user.company_id 
        can :manage, Task, :company_id => @user.company_id 
        can :manage, Client, :company_id => @user.company_id         
        can :manage, ClientBranch, :company_id => @user.company_id 
        can :manage, ClientType, :company_id => @user.company_id 
        can :manage, Family, :company_id => @user.company_id 
        can :manage, Subfamily, :company_id => @user.company_id
        can :manage, ClientBranch, :company_id => @user.company_id 
        can :manage, MeasurementUnit, :company_id => @user.company_id 
        can :manage, Price, :company_id => @user.company_id 
        can :manage, Product, :company_id => @user.company_id 
        can :manage, Stock, :company_id => @user.company_id 
                        
      elsif @user.role.branch_admin == true
        can [:index, :show], Branch 
        can [:edit, :update], Branch, :id => @user.branch_id
        can :manage, Storage, :branch_id => @user.branch_id 
        can :manage, User, :branch_id => @user.branch_id
        can [:new, :create, :show], Comment, :user_id  => @user.id 
        can :manage, Truck, :branch_id => @user.branch_id 
        can :manage, Cellphone, :branch_id => @user.branch_id
        can :manage, Message, :branch_id => @user.branch_id
        can :manage, Driver, :branch_id => @user.branch_id 
        can :manage, Task, :branch_id => @user.branch_id 
        can :manage, Client, :branch_id => @user.branch_id 
        can :manage, ClientBranch, :branch_id => @user.branch_id 
        can :manage, ClientType, :branch_id => @user.branch_id 
        can :manage, Family, :company_id => @user.company_id 
        can :manage, Subfamily, :company_id => @user.company_id 
        can :manage, MeasurementUnit, :branch_id => @user.branch_id 
        can :manage, Price, :branch_id => @user.branch_id 
        can :manage, Product, :company_id => @user.company_id 
        can :manage, Stock, :branch_id => @user.branch_id 
      elsif @user.role.super_manager == true
      elsif @user.role.manager == true
      elsif @user.role.secretary == true
      elsif @user.role.client == true
      elsif @user.role.guess == true
        can [:show, :edit, :update], User, :id => @user.id
      else
      end
    end
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
