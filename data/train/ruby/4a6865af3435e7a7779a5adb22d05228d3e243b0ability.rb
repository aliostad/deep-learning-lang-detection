class Ability
  include CanCan::Ability

  def initialize(person)
    person ||= Ldap::Person.new

    Ldap::Person.class_eval do
      def can_read_person?(person_item)
        true
      end

      def can_manage_person?(person_item)
        group = Ldap::Group.find(Settings.permission['admin_group'])
        group.is_member?(self.dn)
      end

      def can_manage_group?(person_item)
        group = Ldap::Group.find(Settings.permission['admin_group'])
        group.is_member?(self.dn)
      end
    end

    #person
    can :read, Ldap::Person do |person_item|
      person.can_read_person?(person_item)
    end

    can :edit, Ldap::Person do |person_item|
      person.can_manage_person?(person_item)
    end

    can :manage, Ldap::Person do |person_item|
      person.can_manage_person?(person_item)
    end

    #group
    can :manage, Ldap::Group do |group_item|
      person.can_manage_group?(group_item)
    end


    # #Posts
    # can :read, Posts::Post do |post|
    #   user.can_read_post?(post)
    # end
    #
    # can :edit, Posts::Post do |post|
    #   user.can_edit_post?(post)
    # end
    #
    # can :manage, Posts::Post do |post|
    #   user.can_manage_post?
    # end
  end
end