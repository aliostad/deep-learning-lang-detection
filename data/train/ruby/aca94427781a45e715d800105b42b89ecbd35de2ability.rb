class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return if user.new_record?
    if user.has_role?(UserRole::ADMIN)
      can :manage, :all
    elsif user.has_role?(UserRole::DISTRIB_CENTER_MANAGER) || user.has_role?(UserRole::DISTRIB_CENTER_EMPLOYEE)
      can [:access,:view_list, :read, :issue_package], Distribution::Point do |point|
        return true if point.head_user == user.id
        point.employees.map(&:id).include? user.id
      end
      can :manage, Distribution::PackageList
      can :manage, Distribution::Package
      can :manage, Distribution::PackageItem
      can :manage, Distribution::Barcode
      can [:deposit, :balance], User
      can :manage, :order
    else
      can :manage, User, id: user.id
      can :manage, :order
      can :manage, Distribution::Package, :user_id => user.id
      can :manage, Distribution::Barcode, :owner => user.id
      can :manage, Notification, :user_id => user.id
      can :create, Distribution::PackageItem
      can :read, Distribution::Point
    end
  end
end
