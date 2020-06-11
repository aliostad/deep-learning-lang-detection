class MerchantAbility
  include CanCan::Ability
  
  def initialize(merchant)
    @merchant = merchant
    can :manage, Merchant, :id => @merchant.id
    can :read, Invoice, :merchant => { :id => @merchant.id }
    can [:read, :update, :create], Badge, :merchant => { :id => @merchant.id }
    can :manage, CreditCard
    can :manage, Challenge, :merchant => { :id => @merchant.id }
    can :manage, Venue, :merchant => { :id => @merchant.id }
    can :manage, CustomerReward, :merchant => { :id => @merchant.id }
    can [:read, :create], Promotion, :merchant => { :id => @merchant.id }
    can [:read], Customer, :merchant => { :id => @merchant.id }
  end

end