class ArtPolicy < ApplicationPolicy
  MANAGE_ROLES = [Role::ADMIN, Role::TRAINER_LEAD].freeze
  # TODO figure out how ARTs should work, then let more folks see them
  VIEW_ROLES = MANAGE_ROLES

  self::Scope = Struct.new(:user, :scope) do
    def resolve
      if user.has_role? *VIEW_ROLES
        scope.where('1 = 1')
      else
        scope.where("1 = 'No access'")
      end
    end
  end

  def list?
    has_role *VIEW_ROLES
  end

  def show?
    has_role? *VIEW_ROLES
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
    [:audit_comment, :name, :prerequisite, :description]
  end
end
