class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, User
    can :manage, User, :id => user.id

    if user.permissions > User::CLIENT
      if user.permissions == User::ADMIN
        can :manage, Brokerage, :id => user.brokerage.id
        can :manage, User, :brokerage_id => user.brokerage.id
      else
        can :read, Brokerage, :id => user.brokerage.id
        can :read, User, :brokerage_id => user.brokerage.id
      end

      can :manage, Client, :brokerage_id => user.brokerage.id
      can :create, Client

      can :manage, Document do |document|
        document.client.brokerage.id == user.brokerage.id
      end
      can :create, Document
    else
      can :manage, Document do |document|
        document.client.id == user.client_contact.client.id
      end

      cannot :manage, Client
      can :manage, Client do |client|
        client.id == user.client_contact.client.id
      end
    end

    can :manage, RecentClients, :user => user
    can :create, RecentClients

    # Tied directly to the Client.
    can :manage, ClientChange do |change|
      can? :manage, change.client
    end
  end

  def select(collection)
    collection.select { |c| can? :read, c }
  end
end
