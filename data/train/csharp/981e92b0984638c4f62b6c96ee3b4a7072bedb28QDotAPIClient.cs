using Microsoft.Extensions.Options;
using QDot.API.Client.BaseAPI;
using QDot.API.Configuration;
using System;

namespace QDot.API.Client.QDotAPI
{
    public class QDotAPIClient : APIClient
    {
        private readonly ApiClientSettings _apiClientSettings;

        public QDotAPIClient(IOptions<ApiClientSettings> optionsAccessor)
        {
            _apiClientSettings = optionsAccessor.Value;
        }

        protected override string ServiceURL
        {
            get
            {
                return _apiClientSettings.QDotApiUrl;
            }
        }
    }
}
