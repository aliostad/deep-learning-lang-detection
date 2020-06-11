class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user
    
    can :manage, [Profile]
    if user.role? :admin
      can :read, @home
      can :manage, [Course, Lesson, Screen, Sentence, Word]
      cannot :manage, [Bill, Deductible, Payment]
      cannot :read, [Friendship]
      cannot :update, [Account]
      cannot :destroy, [Profile]
      
    elsif user.role? :publisher
      can :manage, Post
    elsif user.role? :client
      can :read, :all
    elsif user.role? :yoda
      can :manage, :all
      
    end
  end
end
