using System;
using System.Configuration;

namespace Vision6
{
    public static class Vision6Configuration
    {
        private static string _apiKey;
        internal const string SupportedApiVersion = "2015-02-09";

        static Vision6Configuration()
        {
            ApiVersion = SupportedApiVersion;
        }

        internal static string GetApiKey()
        {
            if (string.IsNullOrEmpty(_apiKey))
                _apiKey = ConfigurationManager.AppSettings["Vision6ApiKey"];

            return _apiKey;
        }

        public static void SetApiKey(string newApiKey)
        {
            _apiKey = newApiKey;
        }

        public static string ApiVersion { get; internal set; }
    }
}
