using IO.Swagger.Client;
using System;

namespace Timeskip.API
{
    public class SwaggerClient
    {
        private static ApiClient apiClient;

        private SwaggerClient()
        {
        }

        public static ApiClient GetClient()
        {
            if (apiClient == null)
            {
                apiClient = new ApiClient();
                apiClient.RestClient.Timeout = 5000;
                apiClient.RestClient.BaseUrl = new Uri(Timeskip.Properties.Resources.SwaggerUrl);
            }

            return apiClient;
        }
    }
}
