class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.roles.include? :study_admin
      can :manage, :all
    elsif user.roles? :site_coordinator
      can :manage, [Product, Asset, Issue]
    elsif user.roles? :division_coordinator
      can :read, [Product, Asset]
      # manage products, assets he owns
      can :manage, Product do |product|
        product.try(:owner) == user
      end
      can :manage, Asset do |asset|
        asset.assetable.try(:owner) == user
      end
    end
  end
end
