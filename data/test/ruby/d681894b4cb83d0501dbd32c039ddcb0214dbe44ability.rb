class Ability
  include CanCan::Ability
  
  # manage, :destroy, :create, :update

  def initialize(user)
    can :create, [Collection, Category, Monument, MonumentImage]
    # collection
    cannot :manage, Collection
    can :manage, Collection do |e|
      e.user_id == user.id
    end
    # category
    cannot :manage, Category
    can :manage, Category do |e|
      e.user_id == user.id
    end
    # monument
    cannot :manage, Monument
    can :manage, Monument do |e|
      e.collection.user_id == user.id
    end
    # images
    cannot :manage, MonumentImage
    can :manage, MonumentImage do |e|
      e.monument.collection.user_id == user.id
    end
  end
end
