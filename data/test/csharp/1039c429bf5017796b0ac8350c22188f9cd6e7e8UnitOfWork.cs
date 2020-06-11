using Repository.Abstractions.Contos;
using Repository.Abstractions.BusinessPartners;
using Repository.Abstractions.Calculations;
using Repository.Abstractions.Cashiers;
using Repository.Abstractions.Clawbacks;
using Repository.Abstractions.Companies;
using Repository.Abstractions.Documents;
using Repository.Abstractions.ExchangeRates;
using Repository.Abstractions.FixedAssets;
using Repository.Abstractions.Identity;
using Repository.Abstractions.Invoices;
using Repository.Abstractions.Locations;
using Repository.Abstractions.MainFinancialBooks;
using Repository.Abstractions.OrganizationUnits;
using Repository.Abstractions.Products;
using Repository.Abstractions.Reports;
using Repository.Abstractions.Salaries;
using Repository.Abstractions.Warehouses;
using Repository.Abstractions.Warrants;
using Repository.Context;
using Repository.UnitOfWork.Abstractions;
using System;
using Repository.Abstractions.Loans;
using Repository.Abstractions.WritingOffs;
using Repository.Abstractions.Logs;

namespace Repository.UnitOfWork.Implementations
{
    public class UnitOfWork : IUnitOfWork
    {
        private ApplicationDbContext context;

        #region Repository variables

        private IContoRepository contoRepository;

        private IBusinessPartnerBankAccountRepository businessPartnerBankAccountRepository;
        private IBusinessPartnerLocationRepository businessPartnerLocationRepository;
        private IBusinessPartnerPhoneRepository businessPartnerPhoneRepository;
        private IBusinessPartnerRepository businessPartnerRepository;

        private ICalculationsRepository inputCalculationsRepository;
        private IPriceLevelingRepository priceLevelingRepository;
        private IPricingRepository pricingRepository;

        private ICashierRepository cashierRepository;

        private IClawbackFromBuyerRepository clawbackFromBuyerRepository;
        private IClawbackFromSupplierRepository clawbackFromSupplierRepository;

        private ILoanRepository loanRepository;

        private IWritingOffRepository writingOffRepository;

        private ICompanyBankAccountRepository companyBankAccountRepository;
        private ICompanyPhoneRepository companyPhoneRepository;
        private ICompanyRepository companyRepository;

        private IDeliveryNoteRepository deliveryNoteRepository;
        private IInternalDeliveryNoteRepository internalDeliveryNoteRepository;
        private IInputNoteRepository inputNoteRepository;

        private IPassportRepository passportRepository;

        private IExchangeRateRepository exchangeRateRepository;

        private IAuthenticationRepository authenticationRepository;
        private IUserRepository userRepository;

        private IAccountStatementRepository accountStatementRepository;
        private IBookOfOutputInvoicesRepository bookOfOutputInvoicesRepository;
        private ICreditNoteRepository creditNoteRepository;
        private IOutputInvoiceRepository outputInvoiceRepository;
        private IOutputProInvoiceRepository outputProInvoiceRepository;

        private IInputInvoiceRepository inputInvoiceRepository;
        private IAdvanceOutputInvoiceRepository advanceOutputInvoiceRepository;

        private ICountryRepository countryRepository;
        private ICityRepository cityRepository;
        private IExpenseLocationRepository expenseLocationRepository;

        private IMunicipalityRepository municipalityRepository;

        private IOrganizationUnitRepository organizationUnitRepository;
        private ISectionRepository sectionRepository;

        private IProductCardRepository productCardRepository;
        private IProductGroupRepository productGroupRepository;
        private IProductSubGroupRepository productSubGroupRepository;
        private IProductRepository productRepository;
        private IProductSubItemRepository productSubItemRepository;
        private IAnimalTypeRepository animalTypeRepository;
        private IAnimalSubTypeRepository animalSubTypeRepository;
        private IUnitOfMeasurementRepository unitOfMeasurementRepository;
        private IPalletRepository palletRepository;
        private IProductTypeRepository productTypeRepository;
        private IProductVatPercentRepository productVatPercentRepository;

        private IKepuBookRepository kepuBookRepository;

        private IBoxRepository boxRepository;
        private IDepotRepository depotRepository;
        private IStockRepository stockRepository;
        private IWarehouseRepository warehouseRepository;
        private IWarehouseTypeRepository warehouseTypeRepository;
        private IWarehousePriceTypeRepository warehousePriceTypeRepository;

        private IManuelWarrantRepository manuelWarrantRepository;

        private IEmployeeRepository employeeRepository;
        private IEmployeeBankAccountRepository employeeBankAccountRepository;
        private IWorkHourRepository workHourRepository;
        private IWorkTypeRepository workTypeRepository;
        private IDeductionTypeRepository deductionTypeRepository;

        private IContributionRepository contributionRepository;

        private IDeductionRepository deductionRepository;

        private IMonthUtilityRepository monthUtilityRepository;

        private IWarrantTypeRepository warrantTypeRepository;

        private IAmortizationGroupRepository amortizationGroupRepository;
        private IFixedAssetRepository fixedAssetRepository;

        private IMigrationLogRepository migrationLogRepository;

        private IFinancialTemplateRepository financialTemplateRepository;

        private IMainFinancialBookRepository mainFinancialBookRepository;

        #endregion


        #region Constructor

        public UnitOfWork(IContoRepository contoRepository,
             IBusinessPartnerBankAccountRepository businessPartnerBankAccountRepository,
             IBusinessPartnerLocationRepository businessPartnerLocationRepository,
             IBusinessPartnerPhoneRepository businessPartnerPhoneRepository,
             IBusinessPartnerRepository businessPartnerRepository,

             ICalculationsRepository inputCalculationsRepository,
             IPriceLevelingRepository priceLevelingRepository,
             IPricingRepository pricingRepository,

             ICashierRepository cashierRepository,

             IClawbackFromBuyerRepository clawbackFromBuyerRepository,
             IClawbackFromSupplierRepository clawbackFromSupplierRepository,

             ILoanRepository loanRepository,

             IWritingOffRepository writingOffRepository,

             ICompanyBankAccountRepository companyBankAccountRepository,
             ICompanyPhoneRepository companyPhoneRepository,
             ICompanyRepository companyRepository,

             IDeliveryNoteRepository deliveryNoteRepository,
             IInternalDeliveryNoteRepository internalDeliveryNoteRepository,
             IInputNoteRepository inputNoteRepository,

             IPassportRepository passportRepository,

             IExchangeRateRepository exchangeRateRepository,

             IAuthenticationRepository authenticationRepository,
             IUserRepository userRepository,

             IAccountStatementRepository accountStatementRepository,
             IBookOfOutputInvoicesRepository bookOfOutputInvoicesRepository,
             ICreditNoteRepository creditNoteRepository,
             IOutputInvoiceRepository outputInvoiceRepository,
             IInputInvoiceRepository inputInvoiceRepository,
             IOutputProInvoiceRepository outputProInvoiceRepository,



             ICountryRepository countryRepository,
             ICityRepository cityRepository,
             IExpenseLocationRepository expenseLocationRepository,

             IMunicipalityRepository municipalityRepository,

             IOrganizationUnitRepository organizationUnitRepository,
             ISectionRepository sectionRepository,

             IProductCardRepository productCardRepository,
             IProductGroupRepository productGroupRepository,
             IProductSubGroupRepository productSubGroupRepository,
             IProductRepository productRepository,
             IProductSubItemRepository productSubItemRepository,
             IAnimalTypeRepository animalTypeRepository,
             IAnimalSubTypeRepository animalSubTypeRepository,
             IUnitOfMeasurementRepository unitOfMeasurementRepository,
             IPalletRepository palletRepository,

             IProductTypeRepository productTypeRepository,
             IProductVatPercentRepository productVatPercentRepository,

             IKepuBookRepository kepuBookRepository,

             IBoxRepository boxRepository,
             IDepotRepository depotRepository,
             IStockRepository stockRepository,
             IWarehouseRepository warehouseRepository,
             IWarehouseTypeRepository warehouseTypeRepository,
             IWarehousePriceTypeRepository warehousePriceTypeRepository,

             IManuelWarrantRepository manuelWarrantRepository,
             IEmployeeRepository employeeRepository,
             IEmployeeBankAccountRepository employeeBankAccountRepository,
             IWorkHourRepository workHourRepository,
             IWorkTypeRepository workTypeRepository,
             IDeductionTypeRepository deductionTypeRepository,
             IContributionRepository contributionRepository,
             IDeductionRepository deductionRepository,

             IMonthUtilityRepository monthUtilityRepository,

             IWarrantTypeRepository warrantTypeRepository,

             IAmortizationGroupRepository amortizationGroupRepository,
             IFixedAssetRepository fixedAssetRepository,

             IMigrationLogRepository migrationLogRepository,

             IFinancialTemplateRepository financialTemplateRepository,

             IMainFinancialBookRepository mainFinancialBookRepository,

        IAdvanceOutputInvoiceRepository advanceOutputInvoiceRepository)
        {
            this.context = ApplicationDbContext.GetInstance();

            this.contoRepository = contoRepository;

            this.businessPartnerBankAccountRepository = businessPartnerBankAccountRepository;
            this.businessPartnerLocationRepository = businessPartnerLocationRepository;
            this.businessPartnerPhoneRepository = businessPartnerPhoneRepository;
            this.businessPartnerRepository = businessPartnerRepository;

            this.inputCalculationsRepository = inputCalculationsRepository;
            this.priceLevelingRepository = priceLevelingRepository;
            this.pricingRepository = pricingRepository;

            this.cashierRepository = cashierRepository;

            this.clawbackFromBuyerRepository = clawbackFromBuyerRepository;
            this.clawbackFromSupplierRepository = clawbackFromSupplierRepository;

            this.loanRepository = loanRepository;

            this.writingOffRepository = writingOffRepository;

            this.companyBankAccountRepository = companyBankAccountRepository;
            this.companyPhoneRepository = companyPhoneRepository;
            this.companyRepository = companyRepository;

            this.deliveryNoteRepository = deliveryNoteRepository;
            this.internalDeliveryNoteRepository = internalDeliveryNoteRepository;
            this.inputNoteRepository = inputNoteRepository;

            this.passportRepository = passportRepository;

            this.exchangeRateRepository = exchangeRateRepository;

            this.authenticationRepository = authenticationRepository;
            this.userRepository = userRepository;

            this.accountStatementRepository = accountStatementRepository;
            this.bookOfOutputInvoicesRepository = bookOfOutputInvoicesRepository;
            this.creditNoteRepository = creditNoteRepository;
            this.outputInvoiceRepository = outputInvoiceRepository;
            this.outputProInvoiceRepository = outputProInvoiceRepository;


            this.inputInvoiceRepository = inputInvoiceRepository;
            this.advanceOutputInvoiceRepository = advanceOutputInvoiceRepository;

            this.countryRepository = countryRepository;
            this.cityRepository = cityRepository;
            this.expenseLocationRepository = expenseLocationRepository;

            this.municipalityRepository = municipalityRepository;

            this.organizationUnitRepository = organizationUnitRepository;
            this.sectionRepository = sectionRepository;

            this.productCardRepository = productCardRepository;
            this.productGroupRepository = productGroupRepository;
            this.productSubGroupRepository = productSubGroupRepository;
            this.productRepository = productRepository;
            this.productSubItemRepository = productSubItemRepository;
            this.animalTypeRepository = animalTypeRepository;
            this.animalSubTypeRepository = animalSubTypeRepository;
            this.unitOfMeasurementRepository = unitOfMeasurementRepository;
            this.palletRepository = palletRepository;

            this.productTypeRepository = productTypeRepository;
            this.productVatPercentRepository = productVatPercentRepository;

            this.kepuBookRepository = kepuBookRepository;

            this.boxRepository = boxRepository;
            this.depotRepository = depotRepository;
            this.stockRepository = stockRepository;
            this.warehouseRepository = warehouseRepository;
            this.warehouseTypeRepository = warehouseTypeRepository;
            this.warehousePriceTypeRepository = warehousePriceTypeRepository;

            this.manuelWarrantRepository = manuelWarrantRepository;

            this.employeeRepository = employeeRepository;
            this.employeeBankAccountRepository = employeeBankAccountRepository;
            this.deductionTypeRepository = deductionTypeRepository;
            this.workHourRepository = workHourRepository;
            this.workTypeRepository = workTypeRepository;

            this.contributionRepository = contributionRepository;
            this.deductionRepository = deductionRepository;

            this.monthUtilityRepository = monthUtilityRepository;

            this.warrantTypeRepository = warrantTypeRepository;

            this.amortizationGroupRepository = amortizationGroupRepository;
            this.fixedAssetRepository = fixedAssetRepository;

            this.migrationLogRepository = migrationLogRepository;

            this.financialTemplateRepository = financialTemplateRepository;

            this.mainFinancialBookRepository = mainFinancialBookRepository;
        }

        #endregion


        #region Get methods for repositories

        public IContoRepository GetContoRepository()
        {
            return contoRepository;
        }

        public IBusinessPartnerBankAccountRepository GetBusinessPartnerBankAccountRepository()
        {
            return businessPartnerBankAccountRepository;
        }

        public IBusinessPartnerLocationRepository GetBusinessPartnerLocationRepository()
        {
            return businessPartnerLocationRepository;
        }

        public IBusinessPartnerPhoneRepository GetBusinessPartnerPhoneRepository()
        {
            return businessPartnerPhoneRepository;
        }

        public IBusinessPartnerRepository GetBusinessPartnerRepository()
        {
            return businessPartnerRepository;
        }

        public ICalculationsRepository GetInputCalculationsRepository()
        {
            return inputCalculationsRepository;
        }

        public IPriceLevelingRepository GetPriceLevelingRepository()
        {
            return priceLevelingRepository;
        }

        public IPricingRepository GetPricingRepository()
        {
            return pricingRepository;
        }

        public ICashierRepository GetCashierRepository()
        {
            return cashierRepository;
        }

        public IClawbackFromBuyerRepository GetClawbackFromBuyerRepository()
        {
            return clawbackFromBuyerRepository;
        }

        public IClawbackFromSupplierRepository GetClawbackFromSupplierRepository()
        {
            return clawbackFromSupplierRepository;
        }

        public ILoanRepository GetLoanRepository()
        {
            return loanRepository;
        }

        public IWritingOffRepository GetWritingOffRepository()
        {
            return writingOffRepository;
        }

        public ICompanyBankAccountRepository GetCompanyBankAccountRepository()
        {
            return companyBankAccountRepository;
        }

        public ICompanyPhoneRepository GetCompanyPhoneRepository()
        {
            return companyPhoneRepository;
        }

        public ICompanyRepository GetCompanyRepository()
        {
            return companyRepository;
        }

        public IDeliveryNoteRepository GetDeliveryNoteRepository()
        {
            return deliveryNoteRepository;
        }

        public IInternalDeliveryNoteRepository GetInternalDeliveryNoteRepository()
        {
            return internalDeliveryNoteRepository;
        }

        public IInputNoteRepository GetInputNoteRepository()
        {
            return inputNoteRepository;
        }

        public IPassportRepository GetPassportRepository()
        {
            return passportRepository;
        }

        public IExchangeRateRepository GetExchangeRateRepository()
        {
            return exchangeRateRepository;
        }

        public IAuthenticationRepository GetAuthenticationRepository()
        {
            return authenticationRepository;
        }

        public IUserRepository GetUserRepository()
        {
            return userRepository;
        }

        public IAccountStatementRepository GetAccountStatementRepository()
        {
            return accountStatementRepository;
        }

        public IBookOfOutputInvoicesRepository GetBookOfOutputInvoicesRepository()
        {
            return bookOfOutputInvoicesRepository;
        }

        public ICreditNoteRepository GetCreditNoteRepository()
        {
            return creditNoteRepository;
        }

        public IOutputInvoiceRepository GetOutputInvoiceRepository()
        {
            return outputInvoiceRepository;
        }

        public IOutputProInvoiceRepository GetOutputProInvoiceRepository()
        {
            return outputProInvoiceRepository;
        }

        public IAdvanceOutputInvoiceRepository GetAdvanceOutputInvoiceRepository()
        {
            return advanceOutputInvoiceRepository;
        }

        public IInputInvoiceRepository GetInputInvoiceRepository()
        {
            return inputInvoiceRepository;
        }

        public ICountryRepository GetCountryRepository()
        {
            return countryRepository;
        }

        public ICityRepository GetCityRepository()
        {
            return cityRepository;
        }

        public IExpenseLocationRepository GetExpenseLocationRepository()
        {
            return expenseLocationRepository;
        }

        public IMunicipalityRepository GetMunicipalityRepository()
        {
            return municipalityRepository;
        }

        public IOrganizationUnitRepository GetOrganizationUnitRepository()
        {
            return organizationUnitRepository;
        }

        public ISectionRepository GetSectionRepository()
        {
            return sectionRepository;
        }

        public IProductCardRepository GetProductCardRepository()
        {
            return productCardRepository;
        }

        public IProductGroupRepository GetProductGroupRepository()
        {
            return productGroupRepository;
        }

        public IProductSubGroupRepository GetProductSubGroupRepository()
        {
            return productSubGroupRepository;
        }

        public IProductRepository GetProductRepository()
        {
            return productRepository;
        }

        public IProductSubItemRepository GetProductSubItemRepository()
        {
            return productSubItemRepository;
        }

        public IAnimalTypeRepository GetAnimalTypeRepository()
        {
            return animalTypeRepository;
        }

        public IAnimalSubTypeRepository GetAnimalSubTypeRepository()
        {
            return animalSubTypeRepository;
        }

        public IUnitOfMeasurementRepository GetUnitOfMeasurementRepository()
        {
            return unitOfMeasurementRepository;
        }
        public IPalletRepository GetPalletRepository()
        {
            return palletRepository;
        }

        public IProductTypeRepository GetProductTypeRepository()
        {
            return productTypeRepository;
        }

        public IProductVatPercentRepository GetProductVatPercentRepository()
        {
            return productVatPercentRepository;
        }

        public IKepuBookRepository GetKepuBookRepository()
        {
            return kepuBookRepository;
        }

        public IBoxRepository GetBoxRepository()
        {
            return boxRepository;
        }

        public IDepotRepository GetDepotRepository()
        {
            return depotRepository;
        }

        public IStockRepository GetStockRepository()
        {
            return stockRepository;
        }

        public IWarehouseRepository GetWarehouseRepository()
        {
            return warehouseRepository;
        }

        public IWarehouseTypeRepository GetWarehouseTypeRepository()
        {
            return warehouseTypeRepository;
        }

        public IWarehousePriceTypeRepository GetWarehousePriceTypeRepository()
        {
            return warehousePriceTypeRepository;
        }

        public IManuelWarrantRepository GetManuelWarrantRepository()
        {
            return manuelWarrantRepository;
        }

        public IEmployeeRepository GetEmployeeRepository()
        {
            return employeeRepository;
        }


        public IEmployeeBankAccountRepository GetEmployeeBankAccountRepository()
        {
            return employeeBankAccountRepository;
        }

        public IDeductionTypeRepository GetDeductionTypeRepository()
        {
            return deductionTypeRepository;
        }

        public IWorkHourRepository GetWorkHourRepository()
        {
            return workHourRepository;
        }

        public IWorkTypeRepository GetWorkTypeRepository()
        {
            return workTypeRepository;
        }
        public IContributionRepository GetContributionRepository()
        {
            return contributionRepository;
        }

        public IDeductionRepository GetDeductionRepository()
        {
            return deductionRepository;
        }

        public IMonthUtilityRepository GetMonthUtilityRepository()
        {
            return monthUtilityRepository;
        }

        public IWarrantTypeRepository GetWarrantTypeRepository()
        {
            return warrantTypeRepository;
        }

        public IAmortizationGroupRepository GetAmortizationGroupRepository()
        {
            return amortizationGroupRepository;
        }


        public IFixedAssetRepository GetFixedAssetRepository()
        {
            return fixedAssetRepository;
        }

        public IMigrationLogRepository GetMigrationLogRepository()
        {
            return migrationLogRepository;
        }

        public IFinancialTemplateRepository GetFinancialTemplateRepository()
        {
            return financialTemplateRepository;
        }

        public IMainFinancialBookRepository GetMainFinancialBookRepository()
        {
            return mainFinancialBookRepository;
        }

        #endregion


        #region Save method

        public void Save()
        {
            context.SaveChanges();
        }

        #endregion


        #region Dispose 

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion

    }
}
