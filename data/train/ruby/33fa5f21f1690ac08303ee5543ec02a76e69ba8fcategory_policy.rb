class CategoryPolicy < ApplicationPolicy
  def create?
    manage?
  end

  def update?
    manage? && account_owner?
  end

  def reorder?
    manage?
  end

  def destroy?
    manage? && account_owner?
  end

  def manage?
    user.account_admin? || user.menu_admin?
  end

  def account_owner?
    user.account_id == record.menu.account_id
  end

  def permitted_attributes
    [:name, :parent_id]
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where account_id: user.account_id
      end
    end
  end
end
