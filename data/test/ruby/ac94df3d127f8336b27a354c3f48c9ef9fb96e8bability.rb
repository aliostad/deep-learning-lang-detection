class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user
      send(@user.role.presence || :member)
    else
      guest
    end
  end

  def user
    can :manage, UserCalendar, user_id: @user.id
    can :manage, Period
    can :manage, CalendarColor
    can :manage, PricePeriod
    can [:public_list, :show], UserCalendar
    can :destroy, SocialProfile
  end

  def admin
    can :access, :rails_admin
    can :dashboard
    can :manage, UserCalendar
    can :manage, Period
    can :manage, PaymentNotification
    can :manage, CalendarColor
    can :manage, Page
    can :manage, PricePeriod
    can :manage, User
    can :destroy, SocialProfile
  end

  def guest
    can [:public_list, :show], UserCalendar
  end

  def member
  end
end
