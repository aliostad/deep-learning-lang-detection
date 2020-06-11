class Ability
  include CanCan::Ability

  def initialize(user)
    # define_aliases
    user ||= User.new

    # can :manage, :all
    apply_user_rights(user)
  end

  # def define_aliases
  # end

  protected

    def apply_user_rights(user)
      user_id = user.id

      can :manage, [User], :id => user_id

      can :read, [AnimationCategory, AnimationType]

      can :manage, [Animation, Website], :user_id => user_id

      can [:create, :update], Animation, :user_id => user_id

      can :manage, Webpage, :website => { :user_id => user_id }

      can :manage, AnimatedElement, :animation => { :user_id => user_id }

    end

end
