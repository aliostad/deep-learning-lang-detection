using eRecruiter.Api.Parameters;
using eRecruiter.Api.Responses;
using System.Net.Http;

namespace eRecruiter.Api.Client.Requests
{
    public class ApiKeyGetRequest : HttpRequestMessage<ApiKeyResponse>
    {
        public ApiKeyGetRequest(int apiKeyId)
            : base(HttpMethod.Get, "Api/Mandator/ApiKey/" + apiKeyId)
        {
        }
    }

    public class ApiKeyPutRequest : PutJsonHttpRequestMessage<ApiKeyResponse>
    {
        public ApiKeyPutRequest(ApiKeyCreateParameter apiKey)
            : base("Api/Mandator/ApiKey/", apiKey)
        {
        }
    }

    public class ApiKeyPostRequest : PostJsonHttpRequestMessage<ApiKeyResponse>
    {
        public ApiKeyPostRequest(int apiKeyId, ApiKeyUpdateParameter apiKey)
            : base("Api/Mandator/ApiKey/" + apiKeyId, apiKey)
        {
        }
    }

    public class ApiKeyDeleteReqeust : HttpRequestMessage<ApiKeyResponse>
    {
        public ApiKeyDeleteReqeust(int apiKeyId)
            : base(HttpMethod.Delete, "Api/Mandator/ApiKey/" + apiKeyId)
        {
        }
    }
}
