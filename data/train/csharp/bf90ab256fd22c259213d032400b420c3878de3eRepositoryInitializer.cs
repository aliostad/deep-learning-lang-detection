// ************************************************************************** //
// Created by:         Wang, Lu                                               //
// Created date:       Apr 27, 2016                                           //
// Modified by:        Cai, Binbin; Wang, Lu; Xiao, Yiyun;                    //
// Last modified date: Dec 20, 2016                                           //
// Description:        数据访问层初始化器类                                       //
// ************************************************************************** //
using KingsInno.ERP.Common;
using KingsInno.ERP.Common.Initializer;
using KingsInno.ERP.Repository.Sales;
using KingsInno.ERP.Repository.Finance;
using KingsInno.ERP.Repository.HumanResource;
using KingsInno.ERP.Repository.Organization;
using KingsInno.ERP.Repository.Sys;
using KingsInno.ERP.Repository.Unit;
using KingsInno.ERP.Repository.Purchasing;

namespace KingsInno.ERP.Repository
{
    /// <summary>
    /// 数据访问层初始化器类
    /// </summary>
    public class RepositoryInitializer : IRepositoryInitializer
    {
        /// <summary>
        /// 初始化操作
        /// </summary>
        /// <param name="runtime">运行时实例</param>
        public void Initialize(Runtime runtime)
        {
            // Finance
            runtime.RepositoryManager.AddRepository<IAccountBookRepository, AccountBookRepository>();
            runtime.RepositoryManager.AddRepository<IBankAccountRepository, BankAccountRepository>();
            runtime.RepositoryManager.AddRepository<IBankAccountOfEmpRepository, BankAccountOfEmpRepository>();

            // HumanResource
            runtime.RepositoryManager.AddRepository<IEmpCertificationRepository, EmpCertificationRepository>();
            runtime.RepositoryManager.AddRepository<IEmpContactInfoRepository, EmpContactInfoRepository>();
            runtime.RepositoryManager.AddRepository<IEmpEducationExperienceRepository, EmpEducationExperienceRepository>();
            runtime.RepositoryManager.AddRepository<IEmpFamilyMemberRepository, EmpFamilyMemberRepository>();
            runtime.RepositoryManager.AddRepository<IEmployeeRepository, EmployeeRepository>();
            runtime.RepositoryManager.AddRepository<IEmpPositionRepository, EmpPositionRepository>();
            runtime.RepositoryManager.AddRepository<IEmpPositionChangeRepository, EmpPositionChangeRepository>();
            runtime.RepositoryManager.AddRepository<IEmpResumeRepository, EmpResumeRepository>();
            runtime.RepositoryManager.AddRepository<IEmpRewardPunishmentRepository, EmpRewardPunishmentRepository>();
            runtime.RepositoryManager.AddRepository<IEmpSalaryAdjustmentRepository, EmpSalaryAdjustmentRepository>();
            runtime.RepositoryManager.AddRepository<IEmpStatusChangeRepository, EmpStatusChangeRepository>();
            runtime.RepositoryManager.AddRepository<IEmpTrainRecordRepository, EmpTrainRecordRepository>();
            runtime.RepositoryManager.AddRepository<IPositionRepository, PositionRepository>();
            runtime.RepositoryManager.AddRepository<ISalaryLevelRepository, SalaryLevelRepository>();

            // Organization
            runtime.RepositoryManager.AddRepository<ICompanyRepository, CompanyRepository>();
            runtime.RepositoryManager.AddRepository<IDepartmentRepository, DepartmentRepository>();
            runtime.RepositoryManager.AddRepository<IDeptManagerRepository, DeptManagerRepository>();
            runtime.RepositoryManager.AddRepository<IDeptPositionRepository, DeptPositionRepository>();

            //Purcchasing
            runtime.RepositoryManager.AddRepository<IPurchasingOrderRepository, PurchasingOrderRepository>();
            runtime.RepositoryManager.AddRepository<IPurchasingOrderMaterialRepository, PurchasingOrderMaterialRepository>();

            // Sales
            runtime.RepositoryManager.AddRepository<IMakeBillRepository, MakeBillRepository>();    // load test only
            runtime.RepositoryManager.AddRepository<ISalesContractRepository, SalesContractRepository>();
            runtime.RepositoryManager.AddRepository<ISalesContractProductReppository, SalesContractProductReppository>();

            // Sys
            runtime.RepositoryManager.AddRepository<IActionRepository, ActionRepository>();
            runtime.RepositoryManager.AddRepository<IAnnouncementRepository, AnnouncementRepository>();
            runtime.RepositoryManager.AddRepository<IAnnouncementReadRepository, AnnouncementReadRepository>();
            runtime.RepositoryManager.AddRepository<ICityRepository, CityRepository>();
            runtime.RepositoryManager.AddRepository<IContinentRepository, ContinentRepository>();
            runtime.RepositoryManager.AddRepository<ICountryRepository, CountryRepository>();
            runtime.RepositoryManager.AddRepository<ICurrencyRepository, CurrencyRepository>();
            runtime.RepositoryManager.AddRepository<IDataModificationDetailRepository, DataModificationDetailRepository>();
            runtime.RepositoryManager.AddRepository<IDataModificationRepository, DataModificationRepository>();
            runtime.RepositoryManager.AddRepository<IDelegationNavRepositroy, DelegationNavRepositroy>();
            runtime.RepositoryManager.AddRepository<IDelegationRepository, DelegationRepository>();
            runtime.RepositoryManager.AddRepository<IDistrictRepository, DistrictRepository>();
            runtime.RepositoryManager.AddRepository<IFrequentlyUsedRepository, FrequentlyUsedRepository>();
            runtime.RepositoryManager.AddRepository<IGroupRoleRepository, GroupRoleRepository>();
            runtime.RepositoryManager.AddRepository<IGroupRepository, GroupRepository>();
            runtime.RepositoryManager.AddRepository<ILoginAttemptRepository, LoginAttemptRepository>();
            runtime.RepositoryManager.AddRepository<IMeasUnitRepository, MeasUnitRepository>();
            runtime.RepositoryManager.AddRepository<INationRepository, NationRepository>();
            runtime.RepositoryManager.AddRepository<INavigationRepository, NavigationRepository>();
            runtime.RepositoryManager.AddRepository<IOptionGroupRepository, OptionGroupRepository>();
            runtime.RepositoryManager.AddRepository<IOptionPropertyRepository, OptionPropertyRepository>();
            runtime.RepositoryManager.AddRepository<IOptionPropertySettingRepository, OptionPropertySettingRepository>();
            runtime.RepositoryManager.AddRepository<IOptionRepository, OptionRepository>();
            runtime.RepositoryManager.AddRepository<IOptionValueRepository, OptionValueRepository>();
            runtime.RepositoryManager.AddRepository<IProcedureRepository, ProcedureRepository>();
            runtime.RepositoryManager.AddRepository<IPropertyOptionRepository, PropertyOptionRepository>();
            runtime.RepositoryManager.AddRepository<IProvinceRepository, ProvinceRepository>();
            runtime.RepositoryManager.AddRepository<IRoleNavRepository, RoleNavRepository>();
            runtime.RepositoryManager.AddRepository<IRoleRepository, RoleRepository>();
            runtime.RepositoryManager.AddRepository<IServerRecordRepository, ServerRecordRepository>();
            runtime.RepositoryManager.AddRepository<ISessionRepository, SessionRepository>();
            runtime.RepositoryManager.AddRepository<ISolutionSystemRepository, SolutionSystemRepository>();
            runtime.RepositoryManager.AddRepository<IStatusItemRepository, StatusItemRepository>();
            runtime.RepositoryManager.AddRepository<IStatusRepository, StatusRepository>();
            runtime.RepositoryManager.AddRepository<ITableRepository, TableRepository>();
            runtime.RepositoryManager.AddRepository<IUserAccountRecordRepository, UserAccountRecordRepository>();
            runtime.RepositoryManager.AddRepository<IUserGroupRepository, UserGroupRepository>();
            runtime.RepositoryManager.AddRepository<IUserRoleRepository, UserRoleRepository>();
            runtime.RepositoryManager.AddRepository<IUserRepository, UserRepository>();

            //Unit
            runtime.RepositoryManager.AddRepository<IUnitAgreementRepository, UnitAgreementRepository>();
            runtime.RepositoryManager.AddRepository<IUnitCategoryRepository, UnitCategoryRepository>();
            runtime.RepositoryManager.AddRepository<IUnitContactsRepository, UnitContactsRepository>();
            runtime.RepositoryManager.AddRepository<IUnitFinanceRepository, UnitFinanceRepository>();
            runtime.RepositoryManager.AddRepository<IUnitOrganizationRepository, UnitOrganizationRepository>();
        }
    }
}
