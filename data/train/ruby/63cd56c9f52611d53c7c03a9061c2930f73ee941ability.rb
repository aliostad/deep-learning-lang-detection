# To change this template, choose Tools | Templates
# and open the template in the editor.

class Ability
  include CanCan::Ability
  def initialize(user)
    @user = user ||= User.new

    #Uncomment the following two lines, if cancan is break your code or you want to disable the can-can activity.
    #    can :manage, :all
    #    return true

    if user.role? :livia_admin
      can :manage, :all
      can :manage, Matter
      can :manage,ImportHistory
      cannot :manage, Account
      cannot :manage, Contact
      cannot :manage, Opportunity
      cannot :manage, Campaign
      cannot :manage, Physical::Timeandexpenses::TimeEntry
      cannot :manage, TneInvoice
      cannot :manage, :zimbra_mail
      cannot :manage, StickyNote
    else
      can :manage, Communication if user.has_access?(:Communication)
      if user.role? :lawfirm_admin
        lawfirm_admin
      else
        matter  if user.has_access?(:Matters)
        account  if user.has_access?(:Accounts)
        contact  if user.has_access?(:Contacts)
        opportunity  if user.has_access?(:Opportunity)
        campaign  if user.has_access?(:Campaigns)
        time_expense  if user.has_access?('Time & Expense')
        mail if user.has_access?(:Mail)
        report if user.has_access?(:Reports)
        my_favorite if user.has_access?(:Reports)
        workspace if user.has_access?(:Workspace)
        document_repository if user.has_access?('Document Repository')
        favorites if user.has_access?(:Contacts)
        sticky_note
        calendar if user.has_access?(:Contacts)
        utility
        invoices_billing if user.has_access?(:Billing)
        financial_account if user.has_access?(:FinancialAccount)
        matter_subtab_access(user)
      end      
    end
  end

  def lawfirm_admin
    can :manage, :all
    can :read, ServiceProvider
    cannot :manage, ServiceProvider
    cannot :update, ServiceProvider
    cannot :destroy, ServiceProvider

    cannot :index, Company
    cannot :create, Company
    cannot :update, Company
    cannot :destroy, Company

    cannot :manage, Product
    cannot :manage, Subproduct
    cannot :manage, ServiceProvider
    cannot :manage, ProductLicence

    cannot :manage, Account
    cannot :manage, Contact
    cannot :manage, Opportunity
    cannot :manage, Campaign
    cannot :manage, Physical::Timeandexpenses::TimeEntry
    cannot :manage, :zimbra_mail
    cannot :manage, StickyNote
    
  end


  def sticky_note
    if (@user.role?(:livia_admin) ||  @user.role?(:lawfirm_admin) || @user.role?(:team_manager))
      cannot :manage, StickyNote
    else
      can :manage, StickyNote
    end
  end

  def matter
    can :manage, Matter
  end

  def account
    can :manage, Account
  end

  def contact
    can :manage, Contact
  end

  def opportunity
    can :manage, Opportunity
  end

  def campaign
    can :manage, Campaign
  end

  def financial_account
    can :manage, FinancialAccount
    can :manage, FinancialTransaction
  end

  def time_expense
    can :manage, Physical::Timeandexpenses::TimeEntry
    can :manage, Physical::Timeandexpenses::ExpenseEntry    
    can :manage, :time_and_expense

  end

  def mail
    can :manage, :zimbra_mail
  end

  def report
    can :manage, :rpt_contact if @user.has_access?(:Contacts)
    can :manage, :rpt_account if @user.has_access?(:Accounts)
    can :manage, :rpt_campaign if @user.has_access?(:Campaigns)
    can :manage, :rpt_matter if @user.has_access?(:Matters)
    can :manage, :rpt_opportunity if @user.has_access?(:Opportunity)
    can :manage, :rpt_time_and_expense if @user.has_access?('Time & Expense')    
  end

  def my_favorite
    can :manage, :rpt_contact if @user.has_access?(:Contacts)
    can :manage, :rpt_account if @user.has_access?(:Accounts)
    can :manage, :rpt_campaign if @user.has_access?(:Campaigns)
    can :manage, :rpt_matter if @user.has_access?(:Matters)
    can :manage, :rpt_opportunity if @user.has_access?(:Opportunity)
    can :manage, :rpt_time_and_expense if @user.has_access?('Time & Expense')
  end

  def workspace
    can :manage, :workspace  
  end

  def document_repository
    can :manage, :repository
  end

  def favorites
    can :manage, :home
  end

  def calendar
    can :manage, :calendars
  end

  def utility
    can :manage, :utilities
  end
  
  def invoices_billing
    can :manage, TneInvoice 
  end

  def matter_subtab_access(user)
    if user.has_access?(:Matters)
      can :manage, MatterTermcondition if user.has_access?('Terms of Engagement')
      can :manage, MatterPeople if user.has_access?('People & Legal Team')
      can :manage, MatterTask if user.has_access?(:Activities)
      can :manage, MatterIssue if user.has_access?(:Issues)
      can :manage, MatterFact if user.has_access?(:Facts)
      can :manage, MatterRisk if user.has_access?(:Risks)
      can :manage, MatterResearch if user.has_access?(:Researches)
      can :manage, DocumentHome if user.has_access?(:Documents)
      can :manage, MatterBilling  if user.has_access?('Billing & Retainer')
      can :manage, MatterRetainer  if user.has_access?('Billing & Retainer')
      can :manage, Physical::Timeandexpenses::TimeAndExpensesController if user.has_access?('Time and Expense')
    else
      cannot :manage
    end
  end

end
