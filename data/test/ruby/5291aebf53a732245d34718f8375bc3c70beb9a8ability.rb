class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role == 'admin'
      can :manage, :all
    end

    if user.role == 'functionary-dialogue'
      can :manage, DialogueApplication
      can :manage, Faq::Categories
      can :manage, Faq::Questions
    end

    if user.role == 'functionary-participant'
      can :manage, WorkshopApplication
      can :manage, Question
      can :manage, Answer
      can :manage, Participant
      can [:index, :show], User
    end

    if user.role == 'functionary-workshop'
      can :manage, WorkshopApplication
    end

    if user.role == 'participant'
      can [:index, :show, :new, :create], Question
      can :create, Answer
    end
  end
end
