class AccessPolicy
  include AccessGranted::Policy

  def configure
    # Roles are defined in top-to-bottom order, with the highest-privileged
    # role at the top, inheriting permissions from those below.

    # Example policy for AccessGranted.
    # For more details check the README at
    #
    # https://github.com/chaps-io/access-granted/blob/master/README.md
    #

    role :manager, proc { |admin| admin.manager? } do
      can :manage, Admin
      can :manage, Source
      can :manage, Guide
      can :manage, SourceSet
      can :manage, Image
      can :manage, Video
      can :manage, Audio
      can :manage, Document
      can :manage, Tag
      can :manage, Vocabulary
      can :manage, TagSequence
      can :manage, Author
    end

    role :editor, proc { |admin| admin.editor? } do
      can :manage, Source
      can :manage, Guide
      can :manage, SourceSet
      can :manage, Image
      can :manage, Video
      can :manage, Audio
      can :manage, Document
      can :manage, Tag
      can :manage, Vocabulary
      can :manage, TagSequence
      can :manage, Author
    end

    role :reviewer, proc { |admin| admin.reviewer? } do
      can :read, Source
      can :read, Guide
      can :read, SourceSet
    end
  end

  def self.can_manage_content
  end

end
