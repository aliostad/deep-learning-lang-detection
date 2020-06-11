using NGnono.FinancialManagement.Repository.Contract;
using NGnono.FinancialManagement.Repository.Impl;

namespace NGnono.FinancialManagement.WebSupport.Ioc
{
    internal class RepositoryIocRegister : BaseIocRegister
    {
        #region Overrides of BaseIocRegister

        public override void Register()
        {
            Current.Register<IBillRepository, BillRepository>();

            Current.Register<ICustomerRepository, CustomerRepository>();

            Current.Register<IUserAccountRepository, UserAccountRepository>();
        
            Current.Register<IUserRoleRepository, UserRoleRepository>();
            Current.Register<IVUserRoleRepository, VUserRoleRepository>();

            Current.Register<IRoleRepository, RoleRepository>();
            Current.Register<IBrandRepository, BrandRepository>();
            Current.Register<IProductRepository, ProductRepository>();
            Current.Register<IStoreRepository, StoreRepository>();
            Current.Register<ITagRepository, TagRepository>();
        }

        #endregion
    }
}