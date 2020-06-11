class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user
      can :delete_image_comment, Comment do |comment|
        comment.try(:ownerable) == user || user == comment.commentable.imageable.galleryable 
      end 

      can :manage, Cini do |cini|
        ((user.is_creative?) and (cini.try(:user) == user || user.is_cini_admin?(cini)))
      end
      
      can :create, Cini if user.is_creative?
      can :index, Cini if user.is_creative?
      can :manage, Video
      can :manage, Gallery
      can :manage, Image
      can :manage, Need
      can :manage, Role
    end

  end

end
