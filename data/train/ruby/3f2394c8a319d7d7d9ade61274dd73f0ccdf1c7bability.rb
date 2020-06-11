class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'super'
      can :manage, :all
    elsif user.role == 'admin'
      can :manage, Order
      can :manage, OrderItem
      can :manage, ContactHistory
      can :manage, Customer
      can :manage, SettingEmbroidery
      can :manage, SettingFabric
      can :manage, SettingGarment
      can :manage, SettingLabel
      can :manage, SettingMeasurement
      can :manage, SettingPosture
      can :manage, SettingRemark
      can :manage, SettingTemplate
      can :manage, SettingTimeline
      can :manage, Visit
      can [:show, :update], User, :id => user.id
      can [:show, :create], Settings
    elsif user.role == 'outfitter'
      can :manage, Order
      can :manage, OrderItem
      can :manage, Customer
      can [:show, :update], User, :id => user.id
    end
  end
end
