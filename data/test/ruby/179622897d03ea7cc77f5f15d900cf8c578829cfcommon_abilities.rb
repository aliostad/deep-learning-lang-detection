module ArtfullyOse
  module CommonAbilities
    def import_ablilities_for(user)
      can :manage, Import do |chart|
        user.is_in_organization?
      end
    end

    def default_abilities_for(user)
      cannot [ :edit, :destroy ], Show, :live? => true

      can :manage, Organization do |organization|
        user.current_organization.can?( :manage, organization ) && (user == organization.owner)
      end

      can :view, Organization do |organization|
        user.current_organization.can?( :view, organization )
      end

      can :view, Statement do |statement|
        user.is_in_organization?
      end

      can :manage, Search do |search|
        search.organization == user.current_organization
      end
    end

    def ticketing_abilities_for(user)
      can [:manage, :bulk_edit ], Ticket do |ticket|
        user.current_organization.can? :manage, ticket
      end

      #This is the ability that the controller uses to authorize creating/editing an event
      can :manage, Event do |event|
        user.current_organization.can? :manage, event
      end

      can :new, Event do |event|
        user.is_in_organization?
      end

      can :create, :paid_events do
        user.current_organization.can? :access, :paid_ticketing
      end

      can :create_tickets, Array do |sections|
        sections.select {|s| s.price.to_i > 0}.empty? || (user.current_organization.can? :access, :paid_ticketing)
      end

      can [ :manage, :show, :hide, :duplicate ], Show do |show|
        user.current_organization.can?(:manage, show)
      end

      can :manage, Chart do |chart|
        user.current_organization.can? :manage, chart
      end
    end

    def paid_ticketing_abilities_for(user)
      #Nothing here for now
    end

    def order_ablilities_for(user)
      can :manage, Order do |order|
        user.current_organization.can? :manage, order
      end
    end

    def person_abilities_for(user)
      can :manage, Person do |person|
        user.current_organization.can? :manage, person
      end

      can :manage, Segment do |segment|
        user.current_organization.can?(:manage, segment)
      end
    end

    def household_abilities_for(user)
      can :manage, Household do |household|
        (user.current_organization.can? :manage, household)
      end
    end
  end
end
