class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage,          WorkCategory,     user_id: user.id
    can :manage,          ConsolidatedTax,  user_id: user.id
    can :manage,          Customer,         user_id: user.id
    can :manage,          Option,           user_id: user.id
    can :manage,          Certification,    user_id: user.id
    can :manage,          Estimate,         customer: { user_id: user.id }
    can :manage,          Invoice,          customer: { user_id: user.id }
    can :manage,          InvoiceProject,   customer: { user_id: user.id }
    can :manage,          RecurringSlip,    customer: { user_id: user.id }
    can :create,          RecurringSlip
    can :manage,          Slip,             customer: { user_id: user.id }
    can :manage,          WikiPage,         creator_id: user.id
    can :manage,          WikiPageVersion,  updator_id: user.id

    can :manage, TimeEntry do |t|
      t.slip.customer.user.id == user.id
    end

    can :manage,          Tax,              consolidated_tax: { user_id: user.id }
    can :edit,            User,             id: user.id
    can :update,          User,             id: user.id
    can :password_edit,   User,             id: user.id
    can :password_update, User,             id: user.id
    can :destroy_logo,    User,             id: user.id
  end
end
