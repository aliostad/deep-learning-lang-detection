using ThreeBytes.Core.Caching.Abstract;
using ThreeBytes.Core.Caching.Configuration.Abstract;
using ThreeBytes.Core.Service.Concrete;
using ThreeBytes.Email.Dispatch.View.Data.Abstract;
using ThreeBytes.Email.Dispatch.View.Entities;
using ThreeBytes.Email.Dispatch.View.Service.Abstract;

namespace ThreeBytes.Email.Dispatch.View.Service.Concrete
{
    public class EmailDispatchViewEmailMessageService : KeyedGenericService<EmailDispatchViewEmailMessage>, IEmailDispatchViewEmailMessageService
    {
        public EmailDispatchViewEmailMessageService(IEmailDispatchViewEmailMessageRepository repository, ICacheManager cache, IProvideCacheSettings cacheSettings) : base(repository, cache, cacheSettings)
        {
        }
    }
}
