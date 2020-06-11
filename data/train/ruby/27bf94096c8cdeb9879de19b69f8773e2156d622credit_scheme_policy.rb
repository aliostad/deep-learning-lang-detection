class CreditSchemePolicy < ApplicationPolicy
  # Consider creating an OPS_MANAGER role that can manage credit schemes, etc.
  MANAGE_ROLES = [Role::ADMIN].freeze

  self::Scope = Struct.new(:user, :scope) do
    def resolve
      if user
        # everyone can see all schemes
        scope.where('1 = 1')
      else
        scope.where("1 = 'Not logged in'")
      end
    end
  end

  def list?
    # everyone can see all credit schemes
    true
  end

  def show?
    # everyone can see all credit schemes
    true
  end

  def edit?
    manage?
  end

  def create?
    manage?
  end

  def destroy?
    manage?
  end

  def manage?
    has_role? *MANAGE_ROLES
  end

  def audit? ; manage? ; end

  def permitted_attributes
    a = [:audit_comment, :name, :base_hourly_rate, :description,
      {position_ids: []}]
    a << :event_id if record.new_record?
    a
  end
end
