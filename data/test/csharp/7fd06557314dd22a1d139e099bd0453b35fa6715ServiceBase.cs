using CardManagementAPI.Shared.DataObjects;

namespace CardManagementAPI.Shared.Services
{
    public abstract class ServiceBase
    {
        private ApiContextFactory _apiContextFactory;

        private ApiContext _apiContext;
        protected ApiContext ApiContext
        {
            get
            {
                if (this._apiContext == null)
                    this._apiContext = _apiContextFactory.Create();

                return this._apiContext;
            }
        }

        public ServiceBase()
        {
            _apiContextFactory = new ApiContextFactory();
            Mappings.Create();
        }
    }
}
