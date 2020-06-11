class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user.present?
      if user.admin?
        can :manage, :all
      end
      
      can :manage, User, :id => user.id
      can :manage, Apk do |apk|
        user.owns_rom apk.base_rom
      end
      can :create, BaseRom
      can :manage, BaseRom, :uploader => user
      can :manage, Package
      can :manage, BaseRomPackage do |brp|
        user.owns_rom brp.base_rom
      end
    end
    
    can :read, :all
    can :create, Configuration
  end
end