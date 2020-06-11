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
using Repository.Abstractions.Loans;
using Repository.Abstractions.Locations;
using Repository.Abstractions.MainFinancialBooks;
using Repository.Abstractions.OrganizationUnits;
using Repository.Abstractions.Products;
using Repository.Abstractions.Reports;
using Repository.Abstractions.Salaries;
using Repository.Abstractions.Warehouses;
using Repository.Abstractions.Warrants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Repository.Abstractions.WritingOffs;
using Repository.Abstractions.Logs;

namespace Repository.UnitOfWork.Abstractions
{
    public interface IUnitOfWork : IDisposable
    {
        IContoRepository GetContoRepository();

        IBusinessPartnerBankAccountRepository GetBusinessPartnerBankAccountRepository();
        IBusinessPartnerLocationRepository GetBusinessPartnerLocationRepository();
        IBusinessPartnerPhoneRepository GetBusinessPartnerPhoneRepository();
        IBusinessPartnerRepository GetBusinessPartnerRepository();

        ICalculationsRepository GetInputCalculationsRepository();
        IPriceLevelingRepository GetPriceLevelingRepository();
        IPricingRepository GetPricingRepository();

        ICashierRepository GetCashierRepository();

        IClawbackFromBuyerRepository GetClawbackFromBuyerRepository();
        IClawbackFromSupplierRepository GetClawbackFromSupplierRepository();

        ILoanRepository GetLoanRepository();

        IWritingOffRepository GetWritingOffRepository();

        ICompanyBankAccountRepository GetCompanyBankAccountRepository();
        ICompanyPhoneRepository GetCompanyPhoneRepository();
        ICompanyRepository GetCompanyRepository();

        IDeliveryNoteRepository GetDeliveryNoteRepository();
        IInternalDeliveryNoteRepository GetInternalDeliveryNoteRepository();
        IInputNoteRepository GetInputNoteRepository();

        IPassportRepository GetPassportRepository();

        IExchangeRateRepository GetExchangeRateRepository();

        IAuthenticationRepository GetAuthenticationRepository();
        IUserRepository GetUserRepository();

        IAccountStatementRepository GetAccountStatementRepository();
        IBookOfOutputInvoicesRepository GetBookOfOutputInvoicesRepository();
        ICreditNoteRepository GetCreditNoteRepository();
        IOutputInvoiceRepository GetOutputInvoiceRepository();

        IOutputProInvoiceRepository GetOutputProInvoiceRepository();
        IInputInvoiceRepository GetInputInvoiceRepository();
        IAdvanceOutputInvoiceRepository GetAdvanceOutputInvoiceRepository();

        ICountryRepository GetCountryRepository();
        ICityRepository GetCityRepository();
        IExpenseLocationRepository GetExpenseLocationRepository();

        IMunicipalityRepository GetMunicipalityRepository();

        IOrganizationUnitRepository GetOrganizationUnitRepository();
        ISectionRepository GetSectionRepository();

        IProductCardRepository GetProductCardRepository();
        IProductGroupRepository GetProductGroupRepository();
        IProductSubGroupRepository GetProductSubGroupRepository();
        IProductRepository GetProductRepository();
        IProductSubItemRepository GetProductSubItemRepository();
        IAnimalTypeRepository GetAnimalTypeRepository();
        IAnimalSubTypeRepository GetAnimalSubTypeRepository();
        IUnitOfMeasurementRepository GetUnitOfMeasurementRepository();
        IPalletRepository GetPalletRepository();

        IProductTypeRepository GetProductTypeRepository();
        IProductVatPercentRepository GetProductVatPercentRepository();

        IKepuBookRepository GetKepuBookRepository();

        IBoxRepository GetBoxRepository();
        IDepotRepository GetDepotRepository();
        IStockRepository GetStockRepository();
        IWarehouseRepository GetWarehouseRepository();
        IWarehouseTypeRepository GetWarehouseTypeRepository();
        IWarehousePriceTypeRepository GetWarehousePriceTypeRepository();

        IManuelWarrantRepository GetManuelWarrantRepository();

        IEmployeeRepository GetEmployeeRepository();
        IEmployeeBankAccountRepository GetEmployeeBankAccountRepository();
        IWorkHourRepository GetWorkHourRepository();
        IWorkTypeRepository GetWorkTypeRepository();
        IDeductionTypeRepository GetDeductionTypeRepository();

        IContributionRepository GetContributionRepository();

        IDeductionRepository GetDeductionRepository();

        IMonthUtilityRepository GetMonthUtilityRepository();

        IWarrantTypeRepository GetWarrantTypeRepository();

        IAmortizationGroupRepository GetAmortizationGroupRepository();
        IFixedAssetRepository GetFixedAssetRepository();

        IMigrationLogRepository GetMigrationLogRepository();

        IFinancialTemplateRepository GetFinancialTemplateRepository();

        IMainFinancialBookRepository GetMainFinancialBookRepository();

        void Save();
    }
}
