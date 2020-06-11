class Ability
  include CanCan::Ability

  def initialize(current_user)
    @current_user = current_user
    current_user.roles.each do |role|
      self.send(role.role.to_sym)
    end
  end

  def admin
    can :manage, :all
  end

  def staff
    can :manage, :all
  end

  def bike_admin
    can :manage, Bike
    can :manage, ::ActsAsLoggable::Log, :loggable_type => "Bike"
  end

  def user
    can :read, :all
    can :manage, @current_user.bike unless @current_user.bike.nil?
    can :manage, ::ActsAsLoggable::Log, :loggable_type => "Bike", :loggable_id => @current_user.bike_id
    can :manage, ::ActsAsLoggable::Log, :loggable_type => "User", :loggable_id => @current_user.id
  end
end
