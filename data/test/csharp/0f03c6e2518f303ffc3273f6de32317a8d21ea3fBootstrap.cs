using App.Common.DI;
using App.Repository.Impl.Registration;
using App.Repository.Registration;

namespace App.Repository.Impl
{
    public class Bootstrap : App.Common.Tasks.BaseTask<IBaseContainer>, IBootstrapper
    {
        public Bootstrap():base(App.Common.ApplicationType.All)
        {

        }
        public void Execute(IBaseContainer context)
        {
            context.RegisterTransient<IUserRepository, UserRepository>();
            context.RegisterTransient<Repository.Common.ILanguageRepository, App.Repository.Impl.Common.LanguageRepository>();
            context.RegisterTransient<Repository.Secutiry.IRoleRepository, App.Repository.Impl.Security.RoleRepository>();
            context.RegisterTransient<Repository.Secutiry.IPermissionRepository, App.Repository.Impl.Security.PermissionRepository>();
            context.RegisterTransient<Repository.Secutiry.IUserGroupRepository, App.Repository.Impl.Security.UserGroupRepository>();

            context.RegisterTransient<Repository.Common.IFileRepository, App.Repository.Impl.Common.FileRepository>();

            context.RegisterTransient<App.Repository.Setting.IContentTypeRepository, App.Repository.Impl.Setting.ContentTypeRepository>();
            context.RegisterTransient<App.Repository.Common.IParameterRepository, App.Repository.Impl.Common.ParameterRepository>();
        }
    }
}

