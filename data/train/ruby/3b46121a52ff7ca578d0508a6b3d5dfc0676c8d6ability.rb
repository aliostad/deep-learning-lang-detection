class Ability
  include CanCan::Ability

  def initialize(account)
    # Everyone can manage raids that they have admin on
    can :manage, Raid do |raid|
      account.admin?(raid)
    end

    # Admins can manage signups
    # Users can manage their signups
    can :manage, Signup do |signup|
      account.admin?(signup.raid) or account.characters.include?(signup.character)
    end

    # Everyone can read raids that they have available
    can :read, Raid do |raid|
      account.available?(raid)
    end

    # Everyone can manage their own account
    can :manage, Account, :id => account.id

    # Everyone can create raids or signups
    can :create, Raid
  end
end
