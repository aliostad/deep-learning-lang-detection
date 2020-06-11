class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :update, :destroy, :to => :write
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new # guest user (not logged in)
    permission = user.sys_user_permission || SysUserPermission.new

    # manage permission
    if permission.is_super_user?
      can :manage, :all
    end

    if permission.can_manage_all_zenoradio_data?
      can :manage, :all
    end

    if permission.can_manage_all_zenoradio_metadata?
      can :manage, DataEntryway
      can :manage, DataGateway
      can :manage, DataContent
      can :manage, DataGatewayConference
    end

    if permission.can_manage_specific_rca_resources?
    end

    if permission.can_manage_specific_broadcast_resources?
    end

    if permission.can_manage_specific_3rdparty_resources?
    end

  end
end
