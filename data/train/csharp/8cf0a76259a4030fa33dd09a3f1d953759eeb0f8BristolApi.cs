using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BristolApiHackathon.Models;
using RestSharp;
using RestSharp.Authenticators;

namespace BristolApiHackathon.ApiClient
{
    public class BristolApi
    {
        private string ApiUrl => $"https://bristol.api.urbanthings.io/api/{ApiVersion}/";
        private const string ApiVersion = "2.0";
        private readonly string _apiKey;
        private readonly IRestClient _client;

        public BristolApi(string apiKey)
        {
            if (string.IsNullOrWhiteSpace(apiKey)) throw new ArgumentNullException(nameof(apiKey));
            _apiKey = apiKey;

            _client = BuildClient();
        }

        private IRestClient BuildClient() => new RestClient(ApiUrl);

        public ApiResponse Send(BristolApiRequest request)
        {
            request.AddHeader("X-Api-Key", _apiKey);

            var response = _client.Execute<ApiResponse>(request);

            return response.Data;
        }

        public ApiResponse<T> Send<T>(BristolApiRequest request)
        {
            request.AddHeader("X-Api-Key", _apiKey);

            var response = _client.Execute<ApiResponse<T>>(request);

            return response.Data;
        }
    }
}
