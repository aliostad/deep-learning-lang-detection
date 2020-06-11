class Ability
  include CanCan::Ability

  def initialize(user)
    @models = [Quote, SampleCheckout, Note]

    # Cannot do anything by default
    cannot :manage, :all

    if user
      case user.role
      when "admin"
        can :manage, :all
      when "user"
        customer_ids = user.company.customers.pluck("customers.id")

        # Can manage of own user.
        can :manage, User, :id => user.id

        # Can manage samples for the whole company.
        can :manage, Sample, :company_id => user.company.id

        # Can manage customers for the whole company.
        can :manage, Customer, :id => customer_ids

        # Can manage company checkouts.
        can :manage, SampleCheckout, :customer_id => customer_ids
        can :manage, SampleCheckoutSet, :customer_id => customer_ids

        # Can create anything.
        can :create, @models + [Customer, Sample, Charge]

        # Can send and modify invitations.
        can :manage, Invitation, :sender_id => user.id
        can :manage, Invitation, :recipient_id => user.id
        
        #Can see sent email history
        can :read, SentEmail
        
        role = user.company_users.find_by_company_id(user.company).role.downcase
        case role
        when "owner"
          # Can update the information for the company.
          can :update, Company, :id => user.company.id

          # Can manage user connections for the company.
          can :manage, CompanyUser, :company_id => user.company.id

          # Can manage charges for company's quotes.
          can :manage, Charge, :quote => { :customer_id => customer_ids }

          # Can manage the whole company.
          can :manage, @models, :customer_id => customer_ids
        when "salesrep"
          # Can modify charges for own quotes.
          can :manage, Charge, :quote => { :user_id => user.id }
          
          # Can view charges for the whole company's quotes.
          can :read, Charge, :quote => { :customer_id => customer_ids }

          # Can manage own information.
          can :manage, @models, :user_id => user.id
          
          # Can read all the customer information.
          can :read, @models, :customer_id => customer_ids
          
          # Can read the information for the company.
          can :read, Company, :id => user.company.id
        end
      end
    else
      # Not logged in

      can :create, [Company, User]
    end
  end
end
