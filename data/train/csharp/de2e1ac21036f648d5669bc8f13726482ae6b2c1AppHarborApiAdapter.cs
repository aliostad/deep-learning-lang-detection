using System.Collections.Generic;
using AppHarbor;
using AppHarbor.Model;

namespace PSAppHarbor
{
    public class AppHarborApiAdapter : IAppHarborApi
    {
        private readonly AppHarborApi _api;

        public AppHarborApiAdapter(AppHarborApi api)
        {
            _api = api;
        }

        public Application GetApplication(string applicationID)
        {
            return _api.GetApplication(applicationID);
        }

        public IList<Application> GetApplications()
        {
            return _api.GetApplications();
        }


    }
}