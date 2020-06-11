#$Id$#

from books.api.ContactsApi import ContactsApi
from books.api.ContactPersonsApi import ContactPersonsApi
from books.api.EstimatesApi import EstimatesApi
from books.api.InvoicesApi import InvoicesApi
from books.api.RecurringInvoicesApi import RecurringInvoicesApi
from books.api.CreditNotesApi import CreditNotesApi
from books.api.CustomerPaymentsApi import CustomerPaymentsApi
from books.api.ExpensesApi import ExpensesApi
from books.api.RecurringExpensesApi import RecurringExpensesApi
from books.api.BillsApi import BillsApi
from books.api.VendorPaymentsApi import VendorPaymentsApi
from books.api.BankAccountsApi import BankAccountsApi
from books.api.BankTransactionsApi import BankTransactionsApi
from books.api.BankRulesApi import BankRulesApi
from books.api.ChartOfAccountsApi import ChartOfAccountsApi
from books.api.JournalsApi import JournalsApi
from books.api.BaseCurrencyAdjustmentApi import BaseCurrencyAdjustmentApi
from books.api.ProjectsApi import ProjectsApi
from books.api.SettingsApi import SettingsApi
from books.api.ItemsApi import ItemsApi
from books.api.OrganizationsApi import OrganizationsApi
from books.api.UsersApi import UsersApi


class ZohoBooks:
    """
    This class is used to create an object for books service and to provide instance for all APIs.
    """
   
    def __init__(self, authtoken, organization_id):
        """Initialize the parameters for Zoho books.

        Args:
            authtoken(str): User's Authtoken.
            organization_id(str): User's Organization id.

        """
        self.authtoken=authtoken
        self.organization_id=organization_id
    
    def get_contacts_api(self):
        """Get instance for contacts api.
  
        Returns:
            instance: Contacts api instance.

        """
        contacts_api = ContactsApi(self.authtoken, self.organization_id)
        return contacts_api

    def get_contact_persons_api(self):
        """Get instance for contact persons api.
 
        Returns:
            instance: Contact persons api.

        """
        contact_persons_api = ContactPersonsApi(self.authtoken, 
                                                self.organization_id)
        return contact_persons_api
    
    def get_estimates_api(self):
        """Get instance for estimates api.
 
        Returns: 
            instance: Estimates api.

        """
        estimates_api = EstimatesApi(self.authtoken, self.organization_id)
        return estimates_api
    
    def get_invoices_api(self):
        """Get instance for invoice api.
 
        Returns:
            instance: Invoice api.

        """
        invoices_api = InvoicesApi(self.authtoken, self.organization_id)
        return invoices_api

    def get_recurring_invoices_api(self):
        """Get instance for recurring invoices api.

        Returns:
            instance: Recurring invoice api.

        """
        recurring_invoices_api = RecurringInvoicesApi(self.authtoken, \
                                                      self.organization_id)
        return recurring_invoices_api

    def get_creditnotes_api(self):
        """Get instance for creditnotes api.
 
        Returns:
            instance: Creditnotes api.

        """
        creditnotes_api = CreditNotesApi(self.authtoken, self.organization_id)
        return creditnotes_api

    def get_customer_payments_api(self):
        """Get instance for customer payments api.

        Returns:
            instance: Customer payments api.

        """
        customer_payments_api = CustomerPaymentsApi(self.authtoken, 
                                                    self.organization_id)
        return customer_payments_api
    
    def get_expenses_api(self):
        """Get instance for expenses api.
         
        Returns:
            instance: Expenses api.

        """
        expenses_api = ExpensesApi(self.authtoken, self.organization_id)
        return expenses_api
    
    def get_recurring_expenses_api(self):
        """Get instance for recurring expenses api.

        Returns:
            instance: Recurring expenses api.

        """
        recurring_expenses_api = RecurringExpensesApi(self.authtoken, 
                                                     self.organization_id)
        return recurring_expenses_api

    def get_bills_api(self):
        """Get instance for bills api.

        Returns:
            instance: Bills api

        """
        bills_api = BillsApi(self.authtoken, self.organization_id)
        return bills_api

    def get_vendor_payments_api(self):
        """Get instance for vendor payments api.

        Returns:
            instance: vendor payments api

        """
        vendor_payments_api = VendorPaymentsApi(self.authtoken, 
                                                self.organization_id)
        return vendor_payments_api
   
    def get_bank_accounts_api(self):
        """Get instancce for bank accounts api.

        Returns: 
            instance: Bank accounts api.

        """ 
        bank_accounts_api = BankAccountsApi(self.authtoken, 
                                            self.organization_id)
        return bank_accounts_api

    def get_bank_transactions_api(self):
        """Get instance for bank transactions api.

        Returns:
            instance: Bank Transactions api.

        """
        bank_transactions_api = BankTransactionsApi(self.authtoken,
                                                    self.organization_id)
        return bank_transactions_api

    def get_bank_rules_api(self):
        """Get instance for bank rules api.
      
        Returns:
            instance: Bank rules api.

        """
        bank_rules_api = BankRulesApi(self.authtoken, self.organization_id)
        return bank_rules_api
  
    def get_chart_of_accounts_api(self):
        """Get instancce for chart of accounts api

        Returns:
            instance: Chart of accounts api.

        """
        chart_of_accounts_api = ChartOfAccountsApi(self.authtoken, 
                                                   self.organization_id)
        return chart_of_accounts_api

    def get_journals_api(self):
        """Get instance for journals api.
     
        Returns:
            instance: Journals api.

        """
        journals_api = JournalsApi(self.authtoken, self.organization_id)
        return journals_api

    def get_base_currency_adjustment_api(self): 
        """Get instance for base currency adjustment api

        Returns: 
            instance: Base currency adjustments api.

        """
        base_currency_adjustment_api = BaseCurrencyAdjustmentApi(\
                                       self.authtoken, self.organization_id)
        return base_currency_adjustment_api

    def get_projects_api(self):
        """Get instance for projects api.
       
        Returns:
            instance: Projects api.

        """
        projects_api = ProjectsApi(self.authtoken, self.organization_id)
        return projects_api

    def get_settings_api(self):
        """Get instance for settings api.
      
        Returns:
            instance: Settings api.

        """
        settings_api = SettingsApi(self.authtoken, self.organization_id)
        return settings_api

    def get_items_api(self):
        """Get instance for items api.
 
        Returns: 
            instance: Items api.

        """
        items_api = ItemsApi(self.authtoken, self.organization_id)
        return items_api

    def get_users_api(self):
        """Get instance for users api.

        Returns:
            instance: Users api.

        """
        users_api = UsersApi(self.authtoken, self.organization_id)
        return users_api

    def get_organizations_api(self):
        """Get instance for organizations api.

        Returns:
            instance: Organizations api.

        """
        organizations_api = OrganizationsApi(self.authtoken, self.organization_id)
        return organizations_api
