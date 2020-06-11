class Ability
  include CanCan::Ability

  def initialize(user, current_organization=nil)
    return nil unless user.try(:email)
    @current_organization = current_organization

    # a user can manage self.
    can :manage, User, id: user.id

    roles = user.organization_roles.roles_with_access
    admin_roles = roles.select { |role| role.name.eql?(OrganizationRole::ROLE_ADMIN) }
    admin_at = admin_roles.map { |r| r.organization_id }
    admin_or_staff_at = roles.map { |r| r.organization_id }.uniq


    can(:manage, :all) if user.superadmin?

    readable_user_ids = OrganizationRole.where('organization_id in (?)', admin_or_staff_at).pluck(:user_id)
    can :read, User, id: readable_user_ids

    admin_roles_for(admin_at)
    staff_roles_for(admin_or_staff_at)

  end

  def admin_roles_for(oids)
    can :manage, Organization, id: oids
    if @current_organization && oids.include?(@current_organization.id)
      can :manage, Services::UserRoles, organization: @current_organization
      can :create, Services::Invite, organization: @current_organization
    end
  end

  def staff_roles_for(oids)
    can :manage, Account, organization_id: oids
    can :manage, AccountingGroup, organization_id: oids
    can :manage, AccountingPeriod, organization_id: oids
    can :manage, AccountingPlan, organization_id: oids
    can :manage, AccountingClass, organization_id: oids
    can :manage, ClosingBalance, organization_id: oids
    can :manage, ClosingBalanceItem, organization_id: oids
    can :manage, Employee, organization_id: oids
    can :manage, ImportBankFile, organization_id: oids
    can :manage, ImportBankFileRow, organization_id: oids
    can :manage, InkCode, organization_id: oids
    can :manage, Ledger, organization_id: oids
    can :manage, LedgerAccount, organization_id: oids
    can :read,   Organization, id: oids
    can :manage, OpeningBalance, organization_id: oids
    can :manage, OpeningBalanceItem, organization_id: oids
    can :manage, Report, organization_id: oids
    can :manage, Conversion, organization_id: oids
    can :manage, TaxCode, organization_id: oids
    can :manage, Template, organization_id: oids
    can :manage, TemplateItem, organization_id: oids
    can :manage, VatPeriod, organization_id: oids
    can :manage, Verificate, organization_id: oids
    can :manage, VerificateItem, organization_id: oids
    can :manage, Wage, organization_id: oids
    can :manage, WagePeriod, organization_id: oids
  end

end
