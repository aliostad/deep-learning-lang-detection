class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if(user)
      if user.is? :admin 
        #can :manage, :all
      else
        #can :manage, :all
        can :manage, User, id: user.id
        can :manage, Site, user_id: user.id
        can :new, Site
        can :manage, Page, site: {user_id: user.id}
        #can :manage, Section, site: {user_id: user.id}
        #can :read, Section, site: {user_id: user.id}
        can :manage, Section, site: {user_id: user.id}
        
      end
    end
  end
end