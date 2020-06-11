using System;
using System.Collections.Generic;
using System.Text;

namespace Glav.CognitiveServices.FluentApi.Core.Configuration
{
    public class ApiServiceUriCollectionBase
    {
        public const string BASE_URL_TEMPLATE = "https://{0}.api.cognitive.microsoft.com/";
        private Dictionary<ApiActionType, ApiServiceUriFragment> _services = new Dictionary<ApiActionType, ApiServiceUriFragment>();

        protected Dictionary<ApiActionType, ApiServiceUriFragment> Services => _services;

        public ApiServiceUriFragment GetServiceConfig(ApiActionType apiAction)
        {
            return Services[apiAction];
        }
    }
}
