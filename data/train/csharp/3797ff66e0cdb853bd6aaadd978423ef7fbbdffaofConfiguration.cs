using System;
using System.Configuration;

namespace onfleet
{
    public static class ofConfiguration
    {
        private static string _apiKey;
        internal const string SupportedApiVersion = "v2";

        static ofConfiguration()
        {
            ApiVersion = SupportedApiVersion;
        }

        internal static string GetApiKey()
        {
            if (string.IsNullOrEmpty(_apiKey))
                _apiKey = ConfigurationManager.AppSettings["onfleetApiKey"];

            return _apiKey;
        }

        public static void SetApiKey(string newApiKey)
        {
            _apiKey = newApiKey;
        }

        public static string ApiVersion { get; internal set; }
    }
}
