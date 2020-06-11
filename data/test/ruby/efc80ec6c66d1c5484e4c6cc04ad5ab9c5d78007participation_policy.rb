class ParticipationPolicy < ApplicationPolicy


  def index?
    can_manage_event? or user.is_volunteer? if user
  end

  def show?
    can_manage_event? or user.is_volunteer? if user
  end

  def create?
    can_manage_event? if user
  end

  def new?
    can_manage_event? if user
  end

  def update?
    can_manage_event? if user
  end

  def edit?
    can_manage_event? if user
  end

  def destroy?
    can_manage_event? if user
  end

  def record_attendance?
    can_manage_event? if user
  end


  private

    def can_manage_event?
      return true if (user.is_admin? or user.is_event_admin?)
      if record.is_a? Participation
        # can only get event of participation if dealing with object not class
        return true if user.has_role? :event_admin, record.event
      end
    end


end
