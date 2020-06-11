using RestApiClient.Core.Request;
using RestApiClient.Core.Response;
using System.Net.Http;
using System.Threading.Tasks;

namespace RestApiClient.Core
{
    public interface IRestApiClient
    {
        HttpClient HttpClient { get; }

        Task<ApiResult> DeleteAsync(ApiRequest request);
        Task<ApiResult> GetAsync(ApiRequest request);
        Task<ApiResult> PostAsync(ApiRequest request);
        Task<ApiResult> PostAsync<TContent>(ApiRequest<TContent> request);
        Task<ApiResult> PutAsync(ApiRequest request);
        Task<ApiResult> PutAsync<TContent>(ApiRequest<TContent> request);
        Task<ApiResult> SendAsync(ApiRequest<HttpRequestMessage> request);
    }
}
