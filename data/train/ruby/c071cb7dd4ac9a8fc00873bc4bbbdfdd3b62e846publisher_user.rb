# frozen_string_literal: true
module Abilities
  class PublisherUser
    include CanCan::Ability

    def initialize(user)
      can :read,   ::User, id: user.id

      if user.activated?
        can :update, ::User, id: user.id
        can :manage, ::Partner
        can :manage, ::AboutSection
        can :manage, ::Event
        can :manage, ::NewsArticle
        can :manage, ::Activity
        can :manage, ::Publication
        can :manage, ::MediaContent
        can :manage, ::Album
        can :manage, ::Photo
        can :manage, ::Video
        can :manage, ::Graphic
        can :manage, ::Collection
        can :manage, ::VideoCollection
        can :manage, ::Tag
        can :manage, ::Vacancy
        can [:publish, :unpublish], ::MediaContent
        can [:publish, :unpublish, :make_featured, :remove_featured], ::Activity
        can [:publish, :unpublish, :make_featured, :remove_featured], ::Publication
        can [:publish, :unpublish], ::Vacancy
        can [:activate, :deactivate], ::Event
        can [:make_featured, :remove_featured], ::Album
        can [:make_featured, :remove_featured], ::Photo
        can [:make_featured, :remove_featured], ::Video
        can [:make_featured, :remove_featured], ::Graphic
        can [:make_featured, :remove_featured], ::Collection
        can [:make_featured, :remove_featured], ::VideoCollection
      end

      cannot :make_contributor,        ::User, id: user.id
      cannot :make_admin,              ::User, id: user.id
      cannot [:activate, :deactivate], ::User, id: user.id
    end
  end
end
