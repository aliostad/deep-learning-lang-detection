using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Data.Odbc;
using Profit.Server;

namespace Profit
{
    public class RepositoryFactory
    {
        Hashtable m_listService = new Hashtable();
        static volatile RepositoryFactory m_instance;
        public const string BANK_REPOSITORY = "BankRepository";
        public const string CURRENCY_REPOSITORY = "CurrencyRepository";
        public const string DIVISION_REPOSITORY = "DivisionRepository";
        public const string EMPLOYEE_REPOSITORY = "EmployeeRepository";
        public const string TOP_REPOSITORY = "TOPRepository";
        public const string UNIT_REPOSITORY = "UnitRepository";
        public const string CUSTOMER_CATEGORY_REPOSITORY = "CustomerCategoryRepository";
        public const string SUPPLIER_CATEGORY_REPOSITORY = "SupplierCategoryRepository";
        public const string PRICE_CATEGORY_REPOSITORY = "PriceCategoryRepository";
        public const string TAX_REPOSITORY = "TaxRepository";
        public const string PART_GROUP_REPOSITORY = "PartGroupRepository";
        public const string WAREHOUSE_REPOSITORY = "WarehouseRepository";
        public const string PART_CATEGORY_REPOSITORY = "PartCategoryRepository";
        public const string DOC_TYPE_REPOSITORY = "DocTypeRepository";
        public const string EXCHANGE_RATE_REPOSITORY = "ExchangeRateRepository";
        public const string CUSTOMER_REPOSITORY = "CustomerRepository";
        public const string SUPPLIER_REPOSITORY = "SupplierRepository";
        public const string YEAR_REPOSITORY = "YearRepository";
        public const string PART_REPOSITORY = "PartRepository";
        public const string STOCKTAKING_REPOSITORY = "StockTakingRepository";
        public const string USER_REPOSITORY = "UserRepository";
        public const string GENERAL_SETUP_REPOSITORY = "GeneralSetupRepository";
        public const string PURCHASEORDER_REPOSITORY = "PurchaseOrderRepository";
        public const string PERIOD_REPOSITORY = "PeriodRepository";
        public const string USER_SETTING_REPOSITORY = "UserSettingRepository";
        public const string GOODRECEIVENOTE_REPOSITORY = "GoodReceiveNoteRepository";
        public const string PURCHASE_RETURN_REPOSITORY = "PurchaseReturnRepository";
        public const string SUPPLIERINVOICE_REPOSITORY = "SupplierInvoiceRepository";
        public const string SUPPLIERINVOICE_JOURNAL_REPOSITORY = "SupplierInvoiceJournalRepository";
        public const string SUPPLIER_OUTSTANDING_INVOICE_REPOSITORY = "SupplierOutStandingInvoiceRepository";
        public const string PAYMENT_REPOSITORY = "PaymentRepository";
        public const string APDEBITNOTE_REPOSITORY = "APDebitNoteRepository";
        public const string PROCESS_TRANSACTION_REPOSITORY = "ProcessTransactionRepository";
        public const string SALES_ORDER_REPOSITORY = "SalesOrderRepository";
        public const string DELIVERY_ORDER_REPOSITORY = "DeliveryOrderRepository";
        public const string SALES_RETURN_REPOSITORY = "SalesReturnRepository";
        public const string CUSTOMER_OUTSTANDING_INVOICE_REPOSITORY = "CustomerOutStandingInvoiceRepository";
        public const string CUSTOMERINVOICE_REPOSITORY = "CustomerInvoiceRepository";
        public const string RECEIPT_REPOSITORY = "ReceiptRepository";
        public const string ARCREDITNOTE_REPOSITORY = "ARCreditNoteRepository";
        public const string CUSTOMERINVOICE_JOURNAL_REPOSITORY = "CustomerInvoiceJournalRepository";
        public const string OPENING_STOCK_REPOSITORY = "OpeningStockRepository";
        public const string POS_REPOSITORY = "POSRepository";




        public static RepositoryFactory GetInstance()
        {
            if (m_instance == null)
            {
                m_instance = new RepositoryFactory();

            }
            return m_instance;
        }
        public RepositoryFactory()
        {
            Repository bankRepository = new Repository(new Bank());
            CurrencyRepository ccyRepository = new CurrencyRepository();
            Repository divRepository = new Repository(new Division());
            Repository empRepository = new EmployeeRepository(new Employee());
            Repository topRepository = new Repository(new TermOfPayment());
            Repository unitRepository = new Repository(new Unit());
            Repository cuscatRepository = new Repository(new CustomerCategory());
            Repository supcatRepository = new Repository(new SupplierCategory());
            Repository pricecatRepository = new Repository(new PriceCategory());
            Repository taxRepository = new Repository(new Tax());
            Repository prtGroupRepository = new Repository(new PartGroup());
            Repository warehouseRepository = new Repository(new Warehouse());
            Repository prtCategoryRepository = new Repository(new PartCategory());
            Repository docTypeRepository = new Repository(new DocumentType());
            Repository excRateRepository = new Repository(new ExchangeRate());
            CustomerRepository customerRepository = new CustomerRepository();
            SupplierRepository supplierRepository = new SupplierRepository();
            Repository yearRepository = new YearRepository();
            Repository partRepository = new PartRepository(new Part());
            StockTakingRepository stocktakingRepository = new StockTakingRepository();
            UserRepository userRepository = new UserRepository(new User());
            GeneralSetupRepository generalsetupRepository = new GeneralSetupRepository();
            PurchaseOrderRepository poRepository = new PurchaseOrderRepository();
            PeriodRepository periodRepository = new PeriodRepository();
            UserSettingsRepository usRepository = new UserSettingsRepository();
            GoodReceiveNoteRepository grnRepository = new GoodReceiveNoteRepository();
            PurchaseReturnRepository prRepository = new PurchaseReturnRepository();
            SupplierInvoiceRepository siRepository = new SupplierInvoiceRepository();
            SupplierOutStandingInvoiceRepository soiRepository = new SupplierOutStandingInvoiceRepository();
            SupplierInvoiceJournalRepository sijRepository = new SupplierInvoiceJournalRepository();
            PaymentRepository payRepository = new PaymentRepository();
            APDebitNoteRepository apdnRepository = new APDebitNoteRepository();
            ProcessTransactionRepository prtrRepository = new ProcessTransactionRepository();
            SalesOrderRepository slsorderRepository = new SalesOrderRepository();
            DeliveryOrderRepository doRepository = new DeliveryOrderRepository();
            SalesReturnRepository srRepository = new SalesReturnRepository();
            CustomerOutStandingInvoiceRepository coirRepository = new CustomerOutStandingInvoiceRepository();
            CustomerInvoiceRepository cirRepository = new CustomerInvoiceRepository();
            ReceiptRepository rcptRepository = new ReceiptRepository();
            ARCreditNoteRepository arcrRepository = new ARCreditNoteRepository();
            CustomerInvoiceJournalRepository cijRepository = new CustomerInvoiceJournalRepository();
            OpeningStockRepository opstRepository = new OpeningStockRepository();
            POSRepository posRepository = new POSRepository();

            m_listService.Add(BANK_REPOSITORY, bankRepository);
            m_listService.Add(CURRENCY_REPOSITORY, ccyRepository);
            m_listService.Add(DIVISION_REPOSITORY, divRepository);
            m_listService.Add(EMPLOYEE_REPOSITORY, empRepository);
            m_listService.Add(TOP_REPOSITORY, topRepository);
            m_listService.Add(UNIT_REPOSITORY, unitRepository);
            m_listService.Add(CUSTOMER_CATEGORY_REPOSITORY, cuscatRepository);
            m_listService.Add(SUPPLIER_CATEGORY_REPOSITORY, supcatRepository);
            m_listService.Add(PRICE_CATEGORY_REPOSITORY, pricecatRepository);
            m_listService.Add(TAX_REPOSITORY, taxRepository);
            m_listService.Add(PART_GROUP_REPOSITORY, prtGroupRepository);
            m_listService.Add(WAREHOUSE_REPOSITORY, warehouseRepository);
            m_listService.Add(PART_CATEGORY_REPOSITORY, prtCategoryRepository);
            m_listService.Add(DOC_TYPE_REPOSITORY, docTypeRepository);
            m_listService.Add(EXCHANGE_RATE_REPOSITORY, excRateRepository);
            m_listService.Add(CUSTOMER_REPOSITORY, customerRepository);
            m_listService.Add(SUPPLIER_REPOSITORY, supplierRepository);
            m_listService.Add(YEAR_REPOSITORY, yearRepository);
            m_listService.Add(PART_REPOSITORY, partRepository);
            m_listService.Add(STOCKTAKING_REPOSITORY, stocktakingRepository);
            m_listService.Add(USER_REPOSITORY, userRepository);
            m_listService.Add(GENERAL_SETUP_REPOSITORY, generalsetupRepository);
            m_listService.Add(PURCHASEORDER_REPOSITORY, poRepository);
            m_listService.Add(PERIOD_REPOSITORY, periodRepository);
            m_listService.Add(USER_SETTING_REPOSITORY, usRepository);
            m_listService.Add(GOODRECEIVENOTE_REPOSITORY, grnRepository);
            m_listService.Add(PURCHASE_RETURN_REPOSITORY, prRepository);
            m_listService.Add(SUPPLIERINVOICE_REPOSITORY, siRepository);
            m_listService.Add(SUPPLIERINVOICE_JOURNAL_REPOSITORY, sijRepository);
            m_listService.Add(SUPPLIER_OUTSTANDING_INVOICE_REPOSITORY, soiRepository);
            m_listService.Add(PAYMENT_REPOSITORY, payRepository);
            m_listService.Add(APDEBITNOTE_REPOSITORY, apdnRepository);
            m_listService.Add(PROCESS_TRANSACTION_REPOSITORY, prtrRepository);
            m_listService.Add(SALES_ORDER_REPOSITORY, slsorderRepository);
            m_listService.Add(DELIVERY_ORDER_REPOSITORY, doRepository);
            m_listService.Add(SALES_RETURN_REPOSITORY, srRepository);
            m_listService.Add(CUSTOMER_OUTSTANDING_INVOICE_REPOSITORY, coirRepository);
            m_listService.Add(CUSTOMERINVOICE_REPOSITORY, cirRepository);
            m_listService.Add(RECEIPT_REPOSITORY, rcptRepository);
            m_listService.Add(ARCREDITNOTE_REPOSITORY, arcrRepository);
            m_listService.Add(CUSTOMERINVOICE_JOURNAL_REPOSITORY, cijRepository);
            m_listService.Add(OPENING_STOCK_REPOSITORY, opstRepository);
            m_listService.Add(POS_REPOSITORY, posRepository);

        }
        public Repository GetRepository(string name)
        {
            return (Repository)m_listService[name];
        }
        public TransactionRepository GetTransactionRepository(string name)
        {
            return (TransactionRepository)m_listService[name];
        }
        public JournalRepository GetJournalRepository(string name)
        {
            return (JournalRepository)m_listService[name];
        }
        public UserSettingsRepository UserSetting()
        {
            return (UserSettingsRepository)m_listService[USER_SETTING_REPOSITORY];
        }
    }
}
