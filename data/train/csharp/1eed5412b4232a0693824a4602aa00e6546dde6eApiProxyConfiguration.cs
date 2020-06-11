using System;
using System.Configuration;
using DD.ApiProxy.Contracts;

namespace DD.ApiProxy.ApiControllers
{
    /// <summary>
    /// Api Proxy Configuration
    /// </summary>
    public class ApiProxyConfiguration : IApiProxyConfiguration
    {
        private readonly string _apiMocksPath;
        private readonly string _apiRecordingPath;
        private readonly Uri _defaultApiAddress;
        private readonly bool _fallbackToDefaultApi;
        private readonly bool _recordApiRequestResponse;

        public ApiProxyConfiguration()
        {
            _apiMocksPath = ConfigurationManager.AppSettings["ApiMocksPath"];
            var defaultApiAddress = ConfigurationManager.AppSettings["DefaultApiAddress"];
            if (!string.IsNullOrWhiteSpace(defaultApiAddress) && !defaultApiAddress.Contains("http"))
                _defaultApiAddress = new Uri($"https://{defaultApiAddress}/");

            _apiRecordingPath = ConfigurationManager.AppSettings["ApiRecordingPath"];
            var recordApiRequestResponseStr = ConfigurationManager.AppSettings["RecordApiRequestResponse"];
            _recordApiRequestResponse = false;
            bool.TryParse(recordApiRequestResponseStr, out _recordApiRequestResponse);

            _fallbackToDefaultApi = true;
            var fallbackToDefaultApiStr = ConfigurationManager.AppSettings["FallbackToDefaultApi"];
            bool.TryParse(fallbackToDefaultApiStr, out _fallbackToDefaultApi);            
        }

        public string ApiMocksPath
        {
            get { return _apiMocksPath; }
        }

        public string ApiRecordingPath
        {
            get { return _apiRecordingPath; }
        }

        public Uri DefaultApiAddress
        {
            get { return _defaultApiAddress; }
        }

        public bool FallbackToDefaultApi
        {
            get { return _fallbackToDefaultApi; }
        }

        public bool RecordApiRequestResponse
        {
            get { return _recordApiRequestResponse; }
        }
    }
}
