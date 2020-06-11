class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    user ||= User.new # guest user (not logged in)
        if user.has_role? :superadmin
            can :manage, :all

        elsif user.has_role? :manager
          can :manage, Territory
          can :view, User
          can :manage, Owner
          can :manage, CompanyInfo
          can :manage, CustomerQuality
          can :manage, QualityAction
          can :manage, CustomerFeedback
          can :manage, Gauge
          can :manage, CauseAnalysis
          can :manage, Package
          can :manage, Ppap
          can :manage, RunAtRate
          can :manage, Dimension
          can :manage, Material
          can :manage, MaterialElement
          can :manage, Element
          can :manage, ProcessType
          can :manage, Specification
          can :manage, Checklist
          can :manage, Reconcile
          can :manage, GlAccount
          can :manage, GlEntry
          can :manage, PoShipment
          can :manage, SoShipment
          can :manage, QualityLot
          can :manage, Payable
          can :manage, Payment
          can :manage, Receivable
          can :manage, Receipt
          can :manage, CheckEntry
          can :manage, DepositCheck
          can :manage, SoHeader
          can :manage, SoLine
          can :manage, PoHeader
          can :manage, PoLine
          can :manage, Quote
          can :manage, CustomerQuote
          can :manage, CustomerQuoteLine
          can :manage, Organization
          can :manage, Contact
          can :manage, Item

        elsif user.has_role? :operations
          can :manage, Territory
          can :view, Owner
          can :manage, CompanyInfo
          can :manage, CustomerQuality
          can :view, QualityAction
          can :manage, CustomerFeedback
          can :manage, Gauge
          can :manage, CauseAnalysis
          can :manage, Package
          can :manage, Ppap
          can :manage, RunAtRate
          can :manage, Dimension
          can :manage, Material
          can :manage, MaterialElement
          can :manage, Element
          can :manage, ProcessType
          can :manage, Specification
          can :manage, Checklist
          can :view, PoShipment
          can :view, SoShipment
          can :manage, QualityLot
          can :view, Payable
          can :view, Payment
          can :view, Receivable
          can :view, Receipt
          can :manage, SoHeader
          can :manage, SoLine
          can :manage, PoHeader
          can :manage, PoLine
          can :manage, Quote
          can :manage, CustomerQuote
          can :manage, CustomerQuoteLine
          can :manage, Organization
          can :manage, Contact
          can :manage, Item

        elsif user.has_role? :quality
          can :view, CompanyInfo
          can :manage, CustomerQuality
          can :manage, QualityAction
          can :manage, CustomerFeedback
          can :manage, Gauge
          can :manage, CauseAnalysis
          can :manage, Package
          can :manage, Ppap
          can :manage, RunAtRate
          can :manage, Dimension
          can :manage, Material
          can :manage, MaterialElement
          can :manage, Element
          can :manage, ProcessType
          can :manage, Specification
          can :manage, Checklist
          can :manage, PoShipment
          can :manage, SoShipment
          can :manage, QualityLot
          can :view, SoHeader
          can :view, SoLine
          can :view, PoHeader
          can :view, PoLine
          can :manage, Organization
          can :manage, Contact
          can :manage, Item

        elsif user.has_role? :logistics
          can :view, CompanyInfo
          can :view, CustomerQuality
          can :view, QualityAction
          can :manage, CustomerFeedback
          can :view, CauseAnalysis
          can :manage, Package
          can :manage, PoShipment
          can :manage, SoShipment
          can :view, QualityLot
          can :view, SoHeader
          can :view, SoLine
          can :view, PoHeader
          can :view, PoLine
          can :view, Organization
          can :view, Contact
          can :view, Item

        elsif user.has_role? :clerical
          can :view, Owner
          can :view, CompanyInfo
          can :manage, CustomerQuality
          can :manage, QualityAction
          can :manage, CustomerFeedback
          can :manage, CauseAnalysis
          can :view, PoShipment
          can :view, SoShipment
          can :manage, Payable
          can :manage, Payment
          can :manage, Receivable
          can :manage, Receipt
          can :manage, CheckEntry
          can :manage, DepositCheck
          can :manage, SoHeader
          can :manage, SoLine
          can :manage, PoHeader
          can :manage, PoLine
          can :manage, Quote
          can :manage, CustomerQuote
          can :manage, CustomerQuoteLine
          can :manage, Organization
          can :manage, Contact
          can :manage, Item

        elsif user.has_role? :vendor
          can :view, Ppap
          can :view, RunAtRate
          can :view, Dimension
          can :view, Material
          can :view, MaterialElement
          can :view, ProcessType
          can :view, Specification
          can :view, QualityLot
          can :view, PoHeader
          can :view, PoLine
          can :manage, Quote
          can :view, Item

        elsif user.has_role? :customer
          can :view, QualityAction
          can :view, Gauge
          can :view, Package
          can :view, Ppap
          can :view, RunAtRate
          can :view, Dimension
          can :view, Material
          can :view, MaterialElement
          can :view, Element
          can :view, ProcessType
          can :view, Specification
          can :view, QualityLot
          can :view, SoHeader
          can :view, SoLine
          can :view, CustomerQuote
          can :view, CustomerQuoteLine
          can :view, Item
    end




































    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
