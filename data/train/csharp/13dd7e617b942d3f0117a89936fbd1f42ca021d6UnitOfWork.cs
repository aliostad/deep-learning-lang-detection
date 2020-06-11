using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WoodStore.Domain.Models;
using WoodStore.Domain.Repositories;

namespace WoodStore.Domain.Uow
{
    public class UnitOfWork : IUnitOfWork
    {
        private StoresDbContext context = new StoresDbContext();
        private Repository<Bank> bankRepository;
        private Repository<Bank_Branches> bankBranchesRepository;
        private Repository<City> cityRepository;
        private Repository<Company_MainData> companyMainDataRepository;
        private Repository<Country> countryRepository;
        private Repository<Currecny_Converter> currecnyConverterRepository;
        private Repository<Currency> currencyRepository;
        private Repository<Job> jobRepository;
        private Repository<Nationality> nationalityRepository;
        private Repository<District> districtRepository;
        private Repository<Unit> unitRepository;
        private Repository<Unit_Converter> unitConverterRepository;
        private Repository<Language> languageRepository;
        private Repository<Branch> branchRepository;
        private Repository<SuppliersGroup> suppliersGroupRepository;
        private Repository<Suppliers_SubGroup> suppliers_SubGroupRepository;
        private Repository<Privilege> privilegesRepository;
        private Repository<RolePrivilege> rolePrivilegeRepository;
        private Repository<Role> roleRepository;
        private Repository<User> userRepository;
        private Repository<Gender> genderRepository;
        private Repository<Job_Titles> jobTitlesRepository;
        private Repository<Career_Classes> careerClassesRepository;
        private Repository<Allowance> allowanceRepository;
        private Repository<User_Allowances> userAllowancesRepository;
        private Repository<Setting> settingRepository;
        private Repository<EmailConfig> emailConfigRepository;
        private Repository<IndustryType> industryTypeRepository;
        private Repository<Organization_Legal_Entities> organization_Legal_EntitiesRepository;
        private Repository<DryingType> dryingTypeRepository;
        private Repository<Grade> gradeRepository;

        private Repository<PaymentType> paymentTypeRepository;

        private Repository<Product> productRepository;

        private Repository<ProductDetail> productDetailRepository;

        private Repository<Store> storeRepository;

        private Repository<StoreType> storeTypeRepository;

        //private Repository<SupplierProduct> supplierProductRepository;
        private Repository<Category> categoryRepository;
        private Repository<Supplier> supplierRepository;



        private Repository<SerialNoType> serialNoTypeRepository;
        private Repository<StoreTransaction> storeTransactionRepository;
        private Repository<IssuedProduct> issuedProductRepository;
        private Repository<ReceivedProduct> receivedProductRepository;
        private Repository<AdditionType> additionTypeRepository;
        private Repository<IssueType> issueTypeRepository;
        private Repository<StoreTransferenceRecord> storeTransferenceRecordRepository;
        private Repository<TransactionDocument> transactionDocumentRepository;

        private Repository<StoreInventory> storeInventoryRepository;
        private Repository<StoreInventoryDetail> storeInventoryDetailRepository;


        public Repository<StoreInventoryDetail> StoreInventoryDetailRepository
        {
            get
            {
                if (this.storeInventoryDetailRepository == null)
                {
                    this.storeInventoryDetailRepository = new Repository<StoreInventoryDetail>(context);
                }
                return storeInventoryDetailRepository;
            }

        }
        public Repository<StoreInventory> StoreInventoryRepository
        {
            get
            {
                if (this.storeInventoryRepository == null)
                {
                    this.storeInventoryRepository = new Repository<StoreInventory>(context);
                }
                return storeInventoryRepository;
            }

        }
        public Repository<TransactionDocument> TransactionDocumentRepository
        {
            get
            {
                if (this.transactionDocumentRepository == null)
                {
                    this.transactionDocumentRepository = new Repository<TransactionDocument>(context);
                }
                return transactionDocumentRepository;
            }

        }
        public Repository<StoreTransferenceRecord> StoreTransferenceRecordRepository
        {

            get
            {
                if (this.storeTransferenceRecordRepository == null)
                {
                    this.storeTransferenceRecordRepository = new Repository<StoreTransferenceRecord>(context);
                }
                return storeTransferenceRecordRepository;
            }

        }
        public Repository<IssueType> IssueTypeRepository
        {

            get
            {
                if (this.issueTypeRepository == null)
                {
                    this.issueTypeRepository = new Repository<IssueType>(context);
                }
                return issueTypeRepository;
            }

        }
        public Repository<AdditionType> AdditionTypeRepository
        {

            get
            {
                if (this.additionTypeRepository == null)
                {
                    this.additionTypeRepository = new Repository<AdditionType>(context);
                }
                return additionTypeRepository;
            }

        }
        public Repository<ReceivedProduct> ReceivedProductRepository
        {

            get
            {
                if (this.receivedProductRepository == null)
                {
                    this.receivedProductRepository = new Repository<ReceivedProduct>(context);
                }
                return receivedProductRepository;
            }

        }
        public Repository<IssuedProduct> IssuedProductRepository
        {

            get
            {
                if (this.issuedProductRepository == null)
                {
                    this.issuedProductRepository = new Repository<IssuedProduct>(context);
                }
                return issuedProductRepository;
            }

        }
        public Repository<StoreTransaction> StoreTransactionRepository
        {

            get
            {
                if (this.storeTransactionRepository == null)
                {
                    this.storeTransactionRepository = new Repository<StoreTransaction>(context);
                }
                return storeTransactionRepository;
            }

        }
        public Repository<SerialNoType> SerialNoTypeRepository
        {

            get
            {
                if (this.serialNoTypeRepository == null)
                {
                    this.serialNoTypeRepository = new Repository<SerialNoType>(context);
                }
                return serialNoTypeRepository;
            }

        }
        public Repository<Supplier> SupplierRepository
        {

            get
            {
                if (this.supplierRepository == null)
                {
                    this.supplierRepository = new Repository<Supplier>(context);
                }
                return supplierRepository;
            }

        }
        public Repository<Organization_Legal_Entities> Organization_Legal_EntitiesRepository
        {
            get
            {

                if (this.organization_Legal_EntitiesRepository == null)
                {
                    this.organization_Legal_EntitiesRepository = new Repository<Organization_Legal_Entities>(context);
                }
                return organization_Legal_EntitiesRepository;
            }
        }
        public Repository<IndustryType> IndustryTypeRepository
        {
            get
            {

                if (this.industryTypeRepository == null)
                {
                    this.industryTypeRepository = new Repository<IndustryType>(context);
                }
                return industryTypeRepository;
            }
        }

        public Repository<Category> CategoryRepository
        {

            get
            {
                if (this.categoryRepository == null)
                {
                    this.categoryRepository = new Repository<Category>(context);
                }
                return categoryRepository;
            }

        }
        public Repository<DryingType> DryingTypeRepository
        {

            get
            {
                if (this.dryingTypeRepository == null)
                {
                    this.dryingTypeRepository = new Repository<DryingType>(context);
                }
                return dryingTypeRepository;
            }

        }
        public Repository<EmailConfig> EmailConfigRepository
        {

            get
            {
                if (this.emailConfigRepository == null)
                {
                    this.emailConfigRepository = new Repository<EmailConfig>(context);
                }
                return emailConfigRepository;
            }

        }
        public Repository<Setting> SettingRepository
        {

            get
            {
                if (this.settingRepository == null)
                {
                    this.settingRepository = new Repository<Setting>(context);
                }
                return settingRepository;
            }

        }
        public Repository<Grade> GradeRepository
        {
            get
            {
                if (this.gradeRepository == null)
                {
                    this.gradeRepository = new Repository<Grade>(context);
                }
                return gradeRepository;
            }

        }
        public Repository<PaymentType> PaymentTypeRepository
        {

            get
            {
                if (this.paymentTypeRepository == null)
                {
                    this.paymentTypeRepository = new Repository<PaymentType>(context);
                }
                return paymentTypeRepository;
            }

        }
        public Repository<Product> ProductRepository
        {

            get
            {
                if (this.productRepository == null)
                {
                    this.productRepository = new Repository<Product>(context);
                }
                return productRepository;
            }

        }
        public Repository<ProductDetail> ProductDetailRepository
        {

            get
            {
                if (this.productDetailRepository == null)
                {
                    this.productDetailRepository = new Repository<ProductDetail>(context);
                }
                return productDetailRepository;
            }

        }
        public Repository<User_Allowances> UserAllowancesRepository
        {

            get
            {
                if (this.userAllowancesRepository == null)
                {
                    this.userAllowancesRepository = new Repository<User_Allowances>(context);
                }
                return userAllowancesRepository;
            }

        }
        public Repository<Store> StoreRepository
        {

            get
            {
                if (this.storeRepository == null)
                {
                    this.storeRepository = new Repository<Store>(context);
                }
                return storeRepository;
            }

        }
        public Repository<StoreType> StoreTypeRepository
        {

            get
            {
                if (this.storeTypeRepository == null)
                {
                    this.storeTypeRepository = new Repository<StoreType>(context);
                }
                return storeTypeRepository;
            }

        }
      

        public Repository<Gender> GenderRepository
        {
            get
            {

                if (this.genderRepository == null)
                {
                    this.genderRepository = new Repository<Gender>(context);
                }
                return genderRepository;
            }
        }

        public Repository<Job_Titles> JobTitlesRepository
        {
            get
            {

                if (this.jobTitlesRepository == null)
                {
                    this.jobTitlesRepository = new Repository<Job_Titles>(context);
                }
                return jobTitlesRepository;
            }
        }

        public Repository<Career_Classes> CareerClassesRepository
        {
            get
            {

                if (this.careerClassesRepository == null)
                {
                    this.careerClassesRepository = new Repository<Career_Classes>(context);
                }
                return careerClassesRepository;
            }
        }

        public Repository<Allowance> AllowanceRepository
        {
            get
            {

                if (this.allowanceRepository == null)
                {
                    this.allowanceRepository = new Repository<Allowance>(context);
                }
                return allowanceRepository;
            }
        }

        public Repository<Privilege> PrivilegesRepository
        {
            get
            {

                if (this.privilegesRepository == null)
                {
                    this.privilegesRepository = new Repository<Privilege>(context);
                }
                return privilegesRepository;
            }
        }

        public Repository<RolePrivilege> RolePrivilegeRepository
        {
            get
            {

                if (this.rolePrivilegeRepository == null)
                {
                    this.rolePrivilegeRepository = new Repository<RolePrivilege>(context);
                }
                return rolePrivilegeRepository;
            }
        }

        public Repository<Role> RoleRepository
        {
            get
            {

                if (this.roleRepository == null)
                {
                    this.roleRepository = new Repository<Role>(context);
                }
                return roleRepository;
            }
        }

        public Repository<User> UserRepository
        {
            get
            {

                if (this.userRepository == null)
                {
                    this.userRepository = new Repository<User>(context);
                }
                return userRepository;
            }
        }
        public Repository<Suppliers_SubGroup> Suppliers_SubGroupRepository
        {
            get
            {

                if (this.suppliers_SubGroupRepository == null)
                {
                    this.suppliers_SubGroupRepository = new Repository<Suppliers_SubGroup>(context);
                }
                return suppliers_SubGroupRepository;
            }
        }
        public Repository<SuppliersGroup> SuppliersGroupRepository
        {
            get
            {

                if (this.suppliersGroupRepository == null)
                {
                    this.suppliersGroupRepository = new Repository<SuppliersGroup>(context);
                }
                return suppliersGroupRepository;
            }
        }
        public Repository<Branch> BranchRepository
        {
            get
            {

                if (this.branchRepository == null)
                {
                    this.branchRepository = new Repository<Branch>(context);
                }
                return branchRepository;
            }
        }
        public Repository<Language> LanguageRepository
        {
            get
            {

                if (this.languageRepository == null)
                {
                    this.languageRepository = new Repository<Language>(context);
                }
                return languageRepository;
            }
        }
        public Repository<Bank> BankRepository
        {
            get
            {

                if (this.bankRepository == null)
                {
                    this.bankRepository = new Repository<Bank>(context);
                }
                return bankRepository;
            }
        }

        public Repository<Bank_Branches> BankBranchesRepository
        {
            get
            {

                if (this.bankBranchesRepository == null)
                {
                    this.bankBranchesRepository = new Repository<Bank_Branches>(context);
                }
                return bankBranchesRepository;
            }
        }

        public Repository<City> CityRepository
        {
            get
            {
                if (this.cityRepository == null)
                {
                    this.cityRepository = new Repository<City>(context);
                }
                return cityRepository;
            }
        }

        public Repository<Company_MainData> CompanyMainDataRepository
        {
            get
            {
                if (this.companyMainDataRepository == null)
                {
                    this.companyMainDataRepository = new Repository<Company_MainData>(context);
                }
                return companyMainDataRepository;
            }
        }

        public Repository<Country> CountryRepository
        {
            get
            {
                if (this.countryRepository == null)
                {
                    this.countryRepository = new Repository<Country>(context);
                }
                return countryRepository;
            }
        }

        public Repository<Currecny_Converter> CurrecnyConverterRepository
        {
            get
            {
                if (this.currecnyConverterRepository == null)
                {
                    this.currecnyConverterRepository = new Repository<Currecny_Converter>(context);
                }
                return currecnyConverterRepository;
            }
        }

        public Repository<Currency> CurrencyRepository
        {
            get
            {
                if (this.currencyRepository == null)
                {
                    this.currencyRepository = new Repository<Currency>(context);
                }
                return currencyRepository;
            }
        }

        public Repository<Job> JobRepository
        {
            get
            {
                if (this.jobRepository == null)
                {
                    this.jobRepository = new Repository<Job>(context);
                }
                return jobRepository;
            }
        }
        public Repository<Nationality> NationalityRepository
        {
            get
            {
                if (this.nationalityRepository == null)
                {
                    this.nationalityRepository = new Repository<Nationality>(context);
                }
                return nationalityRepository;
            }
        }
        public Repository<District> DistrictRepository
        {
            get
            {
                if (this.districtRepository == null)
                {
                    this.districtRepository = new Repository<District>(context);
                }
                return districtRepository;
            }
        }
        public Repository<Unit> UnitRepository
        {
            get
            {
                if (this.unitRepository == null)
                {
                    this.unitRepository = new Repository<Unit>(context);
                }
                return unitRepository;
            }
        }
        public Repository<Unit_Converter> UnitConverterRepository
        {
            get
            {
                if (this.unitConverterRepository == null)
                {
                    this.unitConverterRepository = new Repository<Unit_Converter>(context);
                }
                return unitConverterRepository;
            }
        }
        public bool Save()
        {
            bool isSaved = false;
            try
            {
                context.SaveChanges();
                isSaved = true;
            }
            catch(Exception ex)
            {
                return isSaved;
            }
            return isSaved;
        }

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
    }
}
