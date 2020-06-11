class EventPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope
      else
        user.events.where published:  true
      end
    end
  end

  def manage?
    user.admin?
  end
  alias_method :create?, :manage?
  alias_method :update?, :manage?
  alias_method :destroy?, :manage?
  alias_method :uploaded?, :manage?

  def download?
    record.zip? && (record.downloadable? || user.admin?)
  end
end
