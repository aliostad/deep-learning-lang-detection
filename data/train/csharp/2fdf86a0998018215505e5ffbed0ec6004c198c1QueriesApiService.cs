using System;
using System.Threading.Tasks;
using VstsDash.RestApi.ApiResponses;
using VstsDash.RestApi.Caching;

namespace VstsDash.RestApi
{
    public class QueriesApiService : IQueriesApiService, IApiService
    {
        private readonly IRestApiClient _apiClient;

        public QueriesApiService(IRestApiClient apiClient)
        {
            _apiClient = apiClient ?? throw new ArgumentNullException(nameof(apiClient));
        }

        public async Task<QueryListApiResponse> GetList(string projectId)
        {
            var url = $"/DefaultCollection/{projectId}/_apis/wit/queries/?api-version=3.0&$expand=wiql&$depth=2";

            return await _apiClient.Get<QueryListApiResponse>(url, CacheDuration.Short);
        }
    }
}