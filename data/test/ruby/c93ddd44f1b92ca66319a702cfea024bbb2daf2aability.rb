class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, User
    can :search, User
    can :manage, Song
    unless user
      
    else
      can :manage, User, id: user.id
      if user.has_role? :performer
        can :manage, Song, user_id: user.id
        can :manage, Video, user_id: user.id
        can :manage, Photo, user_id: user.id
        can :manage, Post, user_id: user.id
        can :manage, Gig, performer_id: user.id
        can :manage, Message, gig: {performer_id: user.id}
      elsif user.has_role? :booker
        can :manage, Gig, booker_id: user.id
        can :manage, Message, gig: {booker_id: user.id}
        can :manage, Review, gig: {booker_id: user.id}
      end
      
      if user.has_role? :admin
        can :manage, :all
      end
    end
  end
end
