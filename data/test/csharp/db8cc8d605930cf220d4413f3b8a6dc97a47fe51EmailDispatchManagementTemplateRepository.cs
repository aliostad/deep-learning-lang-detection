using ThreeBytes.Core.Data.nHibernate.Concrete;
using ThreeBytes.Email.Dispatch.Management.Data.Abstract;
using ThreeBytes.Email.Dispatch.Management.Data.Abstract.Infrastructure;
using ThreeBytes.Email.Dispatch.Management.Entities;

namespace ThreeBytes.Email.Dispatch.Management.Data.Concrete
{
    public class EmailDispatchManagementTemplateRepository : KeyedGenericRepository<EmailDispatchManagementTemplate>, IEmailDispatchManagementTemplateRepository
    {
        public EmailDispatchManagementTemplateRepository(IEmailDispatchManagementDatabaseFactory databaseFactory, IEmailDispatchManagementUnitOfWork unitOfWork) : base(databaseFactory, unitOfWork)
        {
        }

        public EmailDispatchManagementTemplate GetBy(string name, string applicationName)
        {
            return Session.QueryOver<EmailDispatchManagementTemplate>().Where(x => x.Name == name && x.ApplicationName == applicationName).SingleOrDefault();
        }

        public bool UniqueTemplate(string name, string applicationName)
        {
            return Session.QueryOver<EmailDispatchManagementTemplate>().Where(x => x.Name == name && x.ApplicationName == applicationName).RowCount() == 0;
        }
    }
}
