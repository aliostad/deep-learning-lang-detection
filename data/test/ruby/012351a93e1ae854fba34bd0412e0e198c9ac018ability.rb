class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, User, :id => user.id
    can :read, Service

    if user.roles? :admin
      can :manage, :all
    end

    if user.roles? :techadmin
      can :manage, ProxyConfiguration
      can :manage, BrokerConfiguration
    end

    if user.roles? :verwalter
      can :manage, Illness
      can :manage, Medicament
      can :manage, ConflictIllness
      can :manage, ConflictMed
    end

    if user.roles? :arzt
      can :read, Illness
      can :read, Medicament
      can :read, ConflictIllness
      can :read, ConflictMed

      can :manage, Patient
      can :create, Barcode
      can :read, Barcode
      can :manage, BloodPressure
      can :manage, Pulse
      can :manage, Weight
    end

    if user.roles? :pflegekraft
      can :read, Patient
      can :read, Medicament
      can :read, Illness
      can :read, ConflictIllness
      can :read, ConflictMed

      can :manage, BloodPressure
      can :manage, Pulse
      can :manage, Weight
    end

    if user.roles? :dienstnutzer
      can :create, Subscription
      can :read, Subscription, :user_id => user.id
      can :destroy, Subscription, :user_id => user.id
    end

    if user.roles? :dienstanbieter
      can :manage, Service, :owner_id => user.id
    end
  end
end
