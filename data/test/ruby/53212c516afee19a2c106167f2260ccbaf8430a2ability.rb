class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.super_admin?
      can :manage, :all
    elsif user.room_admin?
      can :manage, RoomOrder
      can :manage, Room
      can :manage, Facility
      food_and_room_admin_abilities(user)
    elsif user.food_admin?
      food_and_room_admin_abilities(user)
      food_admin_and_customer_abilities(user)
      can :manage, Food
    elsif user.customer?
      food_admin_and_customer_abilities(user)
      cannot :index, User
      can [:read, :update, :profile], User, id: user.id
    end
  end

  def food_admin_and_customer_abilities(user)
    can :manage, Order::RoomItem do |order_item|
      RoomOrder.where(user_id: user.id, order_id: order_item.order_id).present?
    end
    can [:read, :update, :destroy], RoomOrder, user_id: user.id
    can :manage, RoomOrder, user_id: user.id
  end

  def food_and_room_admin_abilities(user)
    can :manage, Company
    can :manage, User
  end
end
