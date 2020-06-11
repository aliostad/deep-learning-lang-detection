using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WoodStore.Domain.Models;
using WoodStore.Domain.Repositories;

namespace WoodStore.Domain.Uow
{
    public interface IUnitOfWork : IDisposable
    {
         Repository<Organization_Legal_Entities> Organization_Legal_EntitiesRepository { get; }
        Repository<IndustryType> IndustryTypeRepository { get; }
        Repository<Bank> BankRepository { get; }
        Repository<Bank_Branches> BankBranchesRepository { get; }
        Repository<City> CityRepository { get; }
        Repository<Company_MainData> CompanyMainDataRepository { get; }
        Repository<Country> CountryRepository { get; }
        Repository<Currecny_Converter> CurrecnyConverterRepository { get; }
        Repository<Currency> CurrencyRepository { get; }
        Repository<Job> JobRepository { get; }
        Repository<Nationality> NationalityRepository { get; }
        Repository<District> DistrictRepository { get; }
        Repository<Unit> UnitRepository { get; }
        Repository<Unit_Converter> UnitConverterRepository { get; }


        Repository<Language> LanguageRepository { get; }
        Repository<Branch> BranchRepository { get; }
        Repository<SuppliersGroup> SuppliersGroupRepository { get; }
        Repository<Suppliers_SubGroup> Suppliers_SubGroupRepository { get; }

        Repository<Privilege> PrivilegesRepository { get; }
        Repository<RolePrivilege> RolePrivilegeRepository { get; }
        Repository<Role> RoleRepository { get; }
        Repository<User> UserRepository { get; }

        Repository<Gender> GenderRepository { get; }
        Repository<Job_Titles> JobTitlesRepository { get; }
        Repository<Career_Classes> CareerClassesRepository { get; }
        Repository<Allowance> AllowanceRepository { get; }
      
        Repository<User_Allowances> UserAllowancesRepository { get; }
      
        Repository<Setting> SettingRepository { get; }
        Repository<EmailConfig> EmailConfigRepository { get; }


        Repository<DryingType> DryingTypeRepository { get; }
        Repository<Grade> GradeRepository { get; }
        Repository<PaymentType> PaymentTypeRepository { get; }
        Repository<Product> ProductRepository { get; }
        Repository<ProductDetail> ProductDetailRepository { get; }
        Repository<Store> StoreRepository { get; }
        Repository<StoreType> StoreTypeRepository { get; }
        //Repository<SupplierProduct> SupplierProductRepository { get; }
        Repository<Category> CategoryRepository { get; }
        Repository<Supplier> SupplierRepository { get; }
        Repository<SerialNoType> SerialNoTypeRepository { get; }
        Repository<StoreTransaction> StoreTransactionRepository { get; }
        Repository<IssuedProduct> IssuedProductRepository { get; }
        Repository<ReceivedProduct> ReceivedProductRepository { get; }

        Repository<AdditionType> AdditionTypeRepository { get; }
        Repository<IssueType> IssueTypeRepository { get; }
        Repository<StoreTransferenceRecord> StoreTransferenceRecordRepository { get; }
        Repository<TransactionDocument> TransactionDocumentRepository { get; }
        Repository<StoreInventory> StoreInventoryRepository { get; }
        Repository<StoreInventoryDetail> StoreInventoryDetailRepository { get; }

        bool Save();
        //void Dispose();
    }
}
