module Admin
  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user.admin?

      can :read, Order
      can :read, Trade
      can :read, Proof
      can :update, Proof
      can :manage, Document
      can :manage, Member
      can :manage, Ticket
      can :manage, IdDocument
      can :manage, TwoFactor

      can :menu, Deposit
      can :manage, ::Deposits::Bank
      can :manage, ::Deposits::Satoshi
      can :manage, ::Deposits::Czarcoin
      can :manage, ::Deposits::Tetcoin
      can :manage, ::Deposits::Litecoin
      can :manage, ::Deposits::Reddcoin
      can :manage, ::Deposits::Worldcoin
      can :manage, ::Deposits::Paycoin

      can :menu, Withdraw
      can :manage, ::Withdraws::Bank
      can :manage, ::Withdraws::Satoshi
      can :manage, ::Withdraws::Czarcoin
      can :manage, ::Withdraws::Tetcoin
      can :manage, ::Withdraws::Litecoin
      can :manage, ::Withdraws::Reddcoin
      can :manage, ::Withdraws::Worldcoin
      can :manage, ::Withdraws::Paycoin
    end
  end
end
