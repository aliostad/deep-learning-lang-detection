namespace Maestro.DataAccess.Api.ApiClient
{
    /// <summary>
    /// RestApiClientFactory.
    /// </summary>
    /// <seealso cref="Maestro.DataAccess.Api.ApiClient.IRestApiClientFactory" />
    public class RestApiClientFactory : IRestApiClientFactory
    {
        /// <summary>
        /// Creates new instance of IRestApiClient.
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public IRestApiClient Create(string url)
        {
            return new RestApiClient(url);
        }
    }
}