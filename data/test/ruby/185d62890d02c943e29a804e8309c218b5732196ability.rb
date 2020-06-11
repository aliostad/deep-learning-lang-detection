class Ability
  include CanCan::Ability

    def initialize(user)
        user ||= User.new # guest user

        if user.role? Role::ROLES[:premium][:name]
            can :manage, :all
        elsif user.role? Role::ROLES[:business][:name]
            can :manage, [Product, Asset, Issue]
        elsif user.role? Role::ROLES[:basic][:name]
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
