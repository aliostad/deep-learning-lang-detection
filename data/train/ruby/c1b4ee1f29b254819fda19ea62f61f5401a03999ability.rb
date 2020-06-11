class Ability
  include CanCan::Ability

  def initialize(user)

    #
    # Conference owner (its creator)
    #

    # Can manage all in the scope of his/her conference
    can :manage, Conference, owner_id: user.id
    can :manage, ConferenceEdition, conference: { owner_id: user.id }
    can :manage, Image, conference: { owner_id: user.id }
    can :manage, Notification, conference: { owner_id: user.id }
    can :manage, OrganizerInvitation, conference: { owner_id: user.id }
    can :manage, Page, conference: { owner_id: user.id }
    can :manage, Post, conference: { owner_id: user.id }
    can :manage, Slot, conference: { owner_id: user.id }
    can :manage, Speaker, conference: { owner_id: user.id }
    can :manage, Sponsor, conference: { owner_id: user.id }
    can :manage, SponsorContact, conference: { owner_id: user.id }
    can :manage, Subscriber, conference: { owner_id: user.id }
    can :manage, Talk, conference: { owner_id: user.id }

    #
    # Conference organizer
    #

    # Can manage all in the scope of his/her manageable editions
    can :manage, Conference, id: user.manageable_edition_ids
    can :manage, ConferenceEdition, id: user.manageable_edition_ids
    can :manage, Notification, conference_edition_id: user.manageable_edition_ids
    can :manage, OrganizerInvitation, conference_edition_id: user.manageable_edition_ids
    can :manage, Image, conference_edition_id: user.manageable_edition_ids
    can :manage, Page, conference_edition_id: user.manageable_edition_ids
    can :manage, Post, conference_edition_id: user.manageable_edition_ids
    can :manage, Slot, conference_edition_id: user.manageable_edition_ids
    can :manage, Speaker, conference_edition_id: user.manageable_edition_ids
    can :manage, Sponsor, conference_edition_id: user.manageable_edition_ids
    can :manage, SponsorContact, conference_edition_id: user.manageable_edition_ids
    can :manage, Subscriber, conference_edition_id: user.manageable_edition_ids
    can :manage, Talk, conference_edition_id: user.manageable_edition_ids
    can :manage, Ticket, conference_edition_id: user.manageable_edition_ids
    can :manage, Code, conference_edition_id: user.manageable_edition_ids

    # Can read all in the scope of his/her manageable editions' conference
    can :read, Conference, id: user.readable_conference_ids
    can [:read, :appearance, :organizers], ConferenceEdition, conference_id: user.readable_conference_ids

    #
    # Admin
    #

    # Can manage everything, unscoped
    can :manage, :all if user.admin?

  end
end
