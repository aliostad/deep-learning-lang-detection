using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using zohobooks.api;

namespace zohobooks.service
{
    /// <summary>
    /// Class ZohoBooks is used to provide all api instances for the Zoho Books services.
    /// </summary>
    public class ZohoBooks
    {
        /// <summary>
        /// The authentication token
        /// </summary>
        string authToken;
        /// <summary>
        /// The organisation identifier
        /// </summary>
        string organisationId;
        /// <summary>
        /// Initialize ZohoBooks using user's authtoken and organization id.
        /// </summary>
        /// <param name="auth_token">The auth_token is the user's authtoken.</param>
        /// <param name="organization_id">The organization_id is the identifier of the organization.</param>
        public void initialize(string auth_token,string organization_id)
        {
            this.authToken = auth_token;
            this.organisationId = organization_id;
        }
        /// <summary>
        /// Gets an instance of invoices API.
        /// </summary>
        /// <returns>InvoicesApi object.</returns>
        public InvoicesApi GetInvoicesApi()
        {
            var invoicesApi = new InvoicesApi(authToken,organisationId);
            return invoicesApi;
        }
        /// <summary>
        /// Gets an instance of bank accounts API.
        /// </summary>
        /// <returns>BankAccountsApi object.</returns>
        public BankAccountsApi GetBankAccountsApi()
        {
            var bankAccountsApi = new BankAccountsApi(authToken, organisationId);
            return bankAccountsApi;
        }
        /// <summary>
        /// Gets an instance of bank rules API.
        /// </summary>
        /// <returns>BankRulesApi object.</returns>
        public BankRulesApi GetBankRulesApi()
        {
            var bankrulesApi = new BankRulesApi(authToken, organisationId);
            return bankrulesApi;
        }
        /// <summary>
        /// Gets an instance of bank transactions API.
        /// </summary>
        /// <returns>BankTransactionsApi object.</returns>
        public BankTransactionsApi GetBankTransactionsApi()
        {
            var bankTransactionsApi = new BankTransactionsApi(authToken, organisationId);
            return bankTransactionsApi;
        }
        /// <summary>
        /// Gets an instance of base currency adjustments API.
        /// </summary>
        /// <returns>BaseCurrencyAdjustmentsApi object.</returns>
        public BaseCurrencyAdjustmentsApi GetBaseCurrencyAdjustmentsApi()
        {
            var baseCurrencyAdjustmentApi = new BaseCurrencyAdjustmentsApi(authToken, organisationId);
            return baseCurrencyAdjustmentApi;
        }
        /// <summary>
        /// Gets an instance of bills API.
        /// </summary>
        /// <returns>BillsApi object.</returns>
        public BillsApi GetBillsApi()
        {
            var billsApi = new BillsApi(authToken, organisationId);
            return billsApi;
        }
        /// <summary>
        /// Gets an instance of chart of accounts API.
        /// </summary>
        /// <returns>ChartOfAccountsApi object.</returns>
        public ChartOfAccountsApi GetChartOfAccountsApi()
        {
            var chartOfAccountsApi = new ChartOfAccountsApi(authToken, organisationId);
            return chartOfAccountsApi;
        }
        /// <summary>
        /// Gets an instance of contacts API.
        /// </summary>
        /// <returns>ContactsApi object.</returns>
        public ContactsApi GetContactsApi()
        {
            var contactsApi = new ContactsApi(authToken, organisationId);
            return contactsApi;
        }
        /// <summary>
        /// Gets an instance of credit note API.
        /// </summary>
        /// <returns>CreditNotesApi object.</returns>
        public CreditNotesApi GetCreditNoteApi()
        {
            var creditNotesApi = new CreditNotesApi(authToken, organisationId);
            return creditNotesApi;
        }
        /// <summary>
        /// Gets an instance of customer payments API.
        /// </summary>
        /// <returns>CustomerPaymentsApi object.</returns>
        public CustomerPaymentsApi GetCustomerPaymentsApi()
        {
            var customerPaymentsApi = new CustomerPaymentsApi(authToken, organisationId);
            return customerPaymentsApi;
        }
        /// <summary>
        /// Gets an instance of estimates API.
        /// </summary>
        /// <returns>EstimatesApi object.</returns>
        public EstimatesApi GetEstimatesApi()
        {
            var estimatesApi = new EstimatesApi(authToken, organisationId);
            return estimatesApi;
        }
        /// <summary>
        /// Gets an instance of expenses API.
        /// </summary>
        /// <returns>ExpensesApi object.</returns>
        public ExpensesApi GetExpensesApi()
        {
            var expensesApi = new ExpensesApi(authToken, organisationId);
            return expensesApi;
        }
        /// <summary>
        /// Gets an instance of items API.
        /// </summary>
        /// <returns>ItemsApi object.</returns>
        public ItemsApi GetItemsApi()
        {
            var itemsApi = new ItemsApi(authToken, organisationId);
            return itemsApi;
        }
        /// <summary>
        /// Gets an instance of journals API.
        /// </summary>
        /// <returns>JournalsApi object.</returns>
        public JournalsApi GetJournalsApi()
        {
            var journalsApi = new JournalsApi(authToken, organisationId);
            return journalsApi;
        }
        /// <summary>
        /// Gets an instance of organizations API.
        /// </summary>
        /// <returns>OrganizationsApi object.</returns>
        public OrganizationsApi GetOrganizationsApi()
        {
            var organizationsApi = new OrganizationsApi(authToken, organisationId);
            return organizationsApi;
        }
        /// <summary>
        /// Gets an instance of projects API.
        /// </summary>
        /// <returns>ProjectsApi object.</returns>
        public ProjectsApi GetProjectsApi()
        {
            var projectsApi = new ProjectsApi(authToken, organisationId);
            return projectsApi;
        }
        /// <summary>
        /// Gets an instance of recurring expenses API.
        /// </summary>
        /// <returns>RecurringExpensesApi object.</returns>
        public RecurringExpensesApi GetRecurringExpensesApi()
        {
            var recurringExpensesApi = new RecurringExpensesApi(authToken, organisationId);
            return recurringExpensesApi;
        }
        /// <summary>
        /// Gets an instance of recurring invoices API.
        /// </summary>
        /// <returns>RecurringInvoicesApi object.</returns>
        public RecurringInvoicesApi GetRecurringInvoicesApi()
        {
            var recurringInvoicesApi = new RecurringInvoicesApi(authToken, organisationId);
            return recurringInvoicesApi;
        }
        /// <summary>
        /// Gets an instance of settings API.
        /// </summary>
        /// <returns>SettingsApi object.</returns>
        public SettingsApi GetSettingsApi()
        {
            var settingsApi = new SettingsApi(authToken, organisationId);
            return settingsApi;
        }
        /// <summary>
        /// Gets an instance of users API.
        /// </summary>
        /// <returns>UsersApi object.</returns>
        public UsersApi GetUsersApi()
        {
            var usersApi = new UsersApi(authToken, organisationId);
            return usersApi;
        }
        /// <summary>
        /// Gets an instance of vendor payments API.
        /// </summary>
        /// <returns>VendorPaymentsApi object.</returns>
        public VendorPaymentsApi GetVendorPaymentsApi()
        {
            var vendorPaymentsApi = new VendorPaymentsApi(authToken, organisationId);
            return vendorPaymentsApi;
        }
        /// <summary>
        /// Gets an instance of salesorders API.
        /// </summary>
        /// <returns>SalesordersApi.</returns>
        public SalesordersApi GetSalesordersApi()
        {
            var salesordersApi = new SalesordersApi(authToken, organisationId);
            return salesordersApi;
        }
        /// <summary>
        /// Gets the purchaseorders API.
        /// </summary>
        /// <returns>PurchaseordersApi.</returns>
        public PurchaseordersApi GetPurchaseordersApi()
        {
            var purchaseordersApi = new PurchaseordersApi(authToken, organisationId);
            return purchaseordersApi;
        }

        /// <summary>
        /// Gets the vendor credits API.
        /// </summary>
        /// <returns>VendorCreditsApi.</returns>
        public VendorCreditsApi GetVendorCreditsApi()
        {
            var vendorCreditsApi = new VendorCreditsApi(authToken, organisationId);
            return vendorCreditsApi;
        }
    }
}
