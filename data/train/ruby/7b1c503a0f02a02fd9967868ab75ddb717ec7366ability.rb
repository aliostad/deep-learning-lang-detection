class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # guest user

        can :read, :all

        if user.role == 'user'
            can :create, Review
            can :like, Review
            can :dislike, Review
        elsif user.role == 'admin'
            can :manage, :all
        elsif user.role == 'moderator'
            can :create, Review
            can :like, Review
            can :dislike, Review
            can :manage, Product
            can :manage, Game
            can :manage, Album
            can :manage, Show
            can :manage, Movie
            can :index, User
        end
    end
end
