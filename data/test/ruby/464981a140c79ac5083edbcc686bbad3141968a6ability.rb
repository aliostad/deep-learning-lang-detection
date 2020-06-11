# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can(:manage, :all) if user.role?(:admin)

    if user.role? :operator
      can :manage, Image 
      can :manage, CarBaseBrand
      can :manage, CarBaseModel
      can :manage, SearchTree 
      can :manage, LoadConfig, { user_id: user.id }
      can :manage, Article do |article|
        load_package = article.load_package
        load_package.nil? or
        load_package.for_all_users? or
        load_package.creator_id == user.id or
        load_package.user_ids.include?(user.id)
      end
      can :manage, Cross do |cross|
        load_package = cross.load_package
        load_package.nil? or
        load_package.for_all_users? or
        load_package.creator_id == user.id or
        load_package.user_ids.include?(user.id)
      end
      can :manage, LoadPackage do |load_package|
        load_package.for_all_users? or
        load_package.creator_id == user.id or
        load_package.user_ids.include?(user.id)
      end
    end
  end
end
