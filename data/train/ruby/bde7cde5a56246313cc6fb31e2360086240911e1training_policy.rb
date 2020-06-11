class TrainingPolicy < ApplicationPolicy
  # TODO Consider adding attributes to Shift and getting rid or Training
  MANAGE_ROLES = [Role::ADMIN, Role::TRAINER_LEAD].freeze

  self::Scope = Struct.new(:user, :scope) do
    def resolve
      # Anyone can attend a training
      scope.where('1 = 1')
    end
  end

  def list?
    # Everyone can see trainings
    true
  end

  def show?
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
    [:audit_comment, :shift_id, :map_link, :location, :instructions,
      {shift_attributes: [:name, :description, :start_time, :end_time, :event_id]}]
  end
end
