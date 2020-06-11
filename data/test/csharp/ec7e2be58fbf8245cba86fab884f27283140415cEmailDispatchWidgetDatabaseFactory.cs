using ThreeBytes.Core.Data.nHibernate.Concrete;
using ThreeBytes.Email.Dispatch.Widget.Data.Abstract.Infrastructure;

namespace ThreeBytes.Email.Dispatch.Widget.Data.Concrete.Infrastructure
{
    public class EmailDispatchWidgetDatabaseFactory : AbstractDatabaseFactoryBase, IEmailDispatchWidgetDatabaseFactory
    {
        public EmailDispatchWidgetDatabaseFactory(IProvideEmailDispatchWidgetSessionFactoryInitialisation provideSessionFactoryInitialisation)
            : base(provideSessionFactoryInitialisation)
        {
        }
    }
}
