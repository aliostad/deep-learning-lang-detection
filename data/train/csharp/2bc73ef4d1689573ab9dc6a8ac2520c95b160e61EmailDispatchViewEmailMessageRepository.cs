using ThreeBytes.Core.Data.nHibernate.Concrete;
using ThreeBytes.Email.Dispatch.View.Data.Abstract;
using ThreeBytes.Email.Dispatch.View.Data.Abstract.Infrastructure;
using ThreeBytes.Email.Dispatch.View.Entities;

namespace ThreeBytes.Email.Dispatch.View.Data.Concrete
{
    public class EmailDispatchViewEmailMessageRepository : KeyedGenericRepository<EmailDispatchViewEmailMessage>, IEmailDispatchViewEmailMessageRepository
    {
        public EmailDispatchViewEmailMessageRepository(IEmailDispatchViewDatabaseFactory databaseFactory, IEmailDispatchViewUnitOfWork unitOfWork) : base(databaseFactory, unitOfWork)
        {
        }
    }
}
