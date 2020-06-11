class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    send(@user.role) unless (@user.role.nil? || @user.role.blank? )
    #cannot :manage, :all
  end
  
  def admin
    can :manage, User
    can :manage, Product
    cannot :manage, Nasabah
    cannot :manage, Setoran
  end
  
  def director
    can :manage, Nasabah
    cannot :create, Nasabah
    cannot :edit, Nasabah
    cannot :destroy, Nasabah
  end
  
  def cs
    can :manage, Nasabah
  end
  
  def teller
    can :manage, Setoran
  end
end
