using ThreeBytes.Core.Data.nHibernate.Concrete;
using ThreeBytes.Email.Dispatch.Management.Data.Abstract.Infrastructure;

namespace ThreeBytes.Email.Dispatch.Management.Data.Concrete.Infrastructure
{
    public class EmailDispatchManagementDatabaseFactory : AbstractDatabaseFactoryBase, IEmailDispatchManagementDatabaseFactory
    {
        public EmailDispatchManagementDatabaseFactory(IProvideEmailDispatchManagementSessionFactoryInitialisation provideSessionFactoryInitialisation)
            : base(provideSessionFactoryInitialisation)
        {
        }
    }
}
