using Ninject.Modules;
using POS.DAL.Security.Repository;

namespace POS.BLL.Security.IOC
{
    public partial class SecurityRepositoryModule : NinjectModule
    {
        public override void Load()
        {
            Bind<IAccessLogRepository>().To<AccessLogRepository>();
            Bind<IAdditionalOperationPermissionRepository>().To<AdditionalOperationPermissionRepository>();
            Bind<IAdditionalScreenPermissionRepository>().To<AdditionalScreenPermissionRepository>();
            Bind<IApplicationPolicyRepository>().To<ApplicationPolicyRepository>();
            Bind<IApplicationRepository>().To<ApplicationRepository>();
            Bind<IMenuRepository>().To<MenuRepository>();
            Bind<IModuleRepository>().To<ModuleRepository>();
            Bind<IRoleRepository>().To<RoleRepository>();
            Bind<IRoleWiseScreenPermissionRepository>().To<RoleWiseScreenPermissionRepository>();
            Bind<IRoleWiseOperationPermissionRepository>().To<RoleWiseOperationPermissionRepository>();
            Bind<IScreenRepository>().To<ScreenRepository>();
            Bind<IScreenOperationRepository>().To<ScreenOperationRepository>();
            Bind<IUserInformationRepository>().To<UserInformationRepository>();
            Bind<IUserTypeRepository>().To<UserTypeRepository>();
            Bind<IEmployeeInformationRepository>().To<EmployeeInformationRepository>();
        }
    }
}

