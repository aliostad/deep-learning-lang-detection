class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
    	can :manage, Site
    	cannot :create, Site
    	cannot :update, Site
    	cannot :destroy, Site
    	can :read, FeedEntry
    	can :read, Classified
    	can :create, Subscriber
			if user.has_role? :silver
				can :manage, Classified
			end
			if user.has_role? :gold
				can :manage, Classified
			end
			if user.has_role? :platinum
				can :manage, Classified
			end
    end
  end
end
