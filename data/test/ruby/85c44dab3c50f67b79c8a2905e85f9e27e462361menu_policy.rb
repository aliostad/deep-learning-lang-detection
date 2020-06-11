class MenuPolicy < ApplicationPolicy
  def index?
    manage?
  end

  def show?
    manage? && account_owner?
  end

  def create?
    manage?
  end

  def update?
    manage? && account_owner?
  end

  def destroy?
    manage? && account_owner?
  end

  def manage_dishes?
    manage? && account_owner?
  end

  def manage?
    user.account_admin? || user.menu_admin?
  end

  def permitted_attributes
    [:name]
  end

  class Scope < Scope
    def resolve
      scope.where account_id: user.account_id
    end
  end
end
