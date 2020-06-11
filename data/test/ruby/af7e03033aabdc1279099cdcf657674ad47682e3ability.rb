class Ability
  include CanCan::Ability
  
  # commented code is left for example for hostapps. In hostapp developer can override this class for custom authorization requirements
  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      can :manage, :all
      restricted_features_for_admin
    else
      can :manage, :all
      restricted_features_for_admin
      
      cannot :manage , User
      cannot :manage , Gluttonberg::Setting
      cannot :destroy , Gluttonberg::Asset
      
      #page roles
      #cannot :manage , Gluttonberg::Page
      cannot :change_home , Gluttonberg::Page
      cannot :destroy , Gluttonberg::Page
      cannot :publish , Gluttonberg::Page
      cannot :reorder , Gluttonberg::Page
      
      #cannot :manage , Gluttonberg::Blog
      cannot :publish , Gluttonberg::Blog
      cannot :destroy , Gluttonberg::Blog
      
      #cannot :manage , Gluttonberg::Article
      #cannot :publish , Gluttonberg::Article
      #cannot :destroy , Gluttonberg::Article
      
      #cannot :manage , Gluttonberg::Comment
      #cannot :moderate , Gluttonberg::Comment
    end
    
  end
  
  def restricted_features_for_admin
    cannot :manage , Gluttonberg::Locale
    cannot :create_or_destroy , Gluttonberg::Setting
  end
end