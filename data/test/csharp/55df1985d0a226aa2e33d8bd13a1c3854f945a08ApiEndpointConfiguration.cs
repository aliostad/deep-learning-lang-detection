using System;

namespace Chil.Api.Sdk.Communication
{
    public static class ApiEndpointConfiguration
    {
        internal static ApiSettings ApiSettings { get; private set; }

        public static void ConfigureApiSettings(ApiSettings apiSettings)
        {
            if (apiSettings == null)
            {
                throw new ArgumentNullException("apiSettings");
            }

            if (apiSettings.EndpointUrl == null)
            {
                throw new ArgumentNullException("apiSettings.EndPointUrl");
            }

            if (apiSettings.ClientId == null)
            {
                throw new ArgumentNullException("apiSettings.ClientId");
            }

            if (apiSettings.ClientSecret == null)
            {
                throw new ArgumentNullException("apiSettings.ClientSecret");
            }

            ApiSettings = apiSettings;
        }
    }
}
