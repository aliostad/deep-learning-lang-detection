class Ability
  include CanCan::Ability

  def initialize(user)
    # guest user (not logged in)
    unless user
      user = User.new
      user.role = 'guest'
    end

    if user.admin?
      can :manage, :all
    end

    if user.regular? or user.lojista?
      models = [Box, Customer, *provider_models]
      can :manage, models#, user_id: [user.id]

      can :manage, Account  #, owner_ids:  user.id
      can :manage, Dashboard do |dashboard|
        dashboard.users.include?(user)
      end
      can :manage, Dashboard if user.lojista?

      can :create, [Box, Customer, Dashboard]

      can :manage, User, id: user.id
    end
  end

  def provider_models
    %W(Item Picture MeliInfo ItemStorage Question Shipping Payment Feedback Label).map { |name| "Mercadolibre::#{name}".constantize }
  end
end
