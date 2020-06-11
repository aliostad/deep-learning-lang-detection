using Microsoft.Extensions.Options;
using QDot.API.Configuration;
using QDot.Location.API.Client.BaseAPI;

namespace QDot.Location.API.Client.Zippopotam
{
    public class ZippopotamClient : APIClient
    {
        private readonly IOptions<ApiClientSettings> _apiClientSettings;

        public ZippopotamClient(IOptions<ApiClientSettings> apiClientSettings)
        {
            _apiClientSettings = apiClientSettings;
        }

        protected override string ServiceURL
        {
            get
            {
                return _apiClientSettings.Value.ZippopotamUrl;
            }
        }
    }
}
