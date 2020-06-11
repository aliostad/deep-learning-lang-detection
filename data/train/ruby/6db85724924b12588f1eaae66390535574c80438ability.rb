class Ability
  include CanCan::Ability

  def initialize(user)

      user ||= ApplicationUser.new

      if user.role == 'admin'
        can :manage, :all
        can :assign, :all
        can :import, :all

      elsif user.role == 'normal'
        can :show, Domain
        can :manage, Domain, :application_user_id => user.id
        can :manage, Person, :application_user_id => user.id
        can :manage, Score
        can :manage, Rule

        cannot :import, Person
        cannot :import, Domain
      end
  end
end
