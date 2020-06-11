class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, User
    can :manage, Person
    can :manage, Alert
    can :manage, History
    can :manage, Family
    can :manage, Article
    can :manage, Sandwich
    can :manage, Attachment

    if user.has_role? :director
      cannot :show, User do |usuario|
       usuario.has_role? :director and user != usuario
      end

      cannot :destroy, User do |usuario|
       usuario.has_role? :director
      end
    elsif user.has_role? :worker
      cannot :destroy, User do |usuario|
        usuario.has_role? :worker or usuario.has_role? :director
      end

      cannot :show, User do |usuario|
        (usuario.has_role? :worker and user != usuario) or usuario.has_role? :director
      end
    elsif user.has_role? :volunteer
      cannot [:index, :create, :destroy], User
      cannot [:create, :update, :destroy], Family

      cannot [:show, :update], User do |usuario|
        user != usuario
      end

      cannot :manage, History
      cannot :manage, Alert
    end
  end
end
