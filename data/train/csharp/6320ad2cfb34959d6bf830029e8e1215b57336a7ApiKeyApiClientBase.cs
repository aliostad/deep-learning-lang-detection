using System.Net.Http;
using Api.Client.Toolkit.Authentication.ApiKey;

namespace Api.Client.Toolkit.WebApi.Authentication.ApiKey
{
    public class ApiKeyApiClientBase : ApiClientBase
    {
        protected ApiKeyApiClientBase(IApiKeyApiClientSettings settings)
            : base(settings)
        {
        }

        protected override HttpClient CreateHttpClient()
        {
            var client = base.CreateHttpClient();

            client.DefaultRequestHeaders.Add("Authorization", ((IApiKeyApiClientSettings)Settings).ApiKey);

            return client;
        }
    }
}
