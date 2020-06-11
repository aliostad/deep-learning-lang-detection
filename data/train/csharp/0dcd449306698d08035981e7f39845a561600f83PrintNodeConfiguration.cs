namespace PrintNode.Net
{
    public static class PrintNodeConfiguration
    {
        private static string _apiKey;
        internal const int SupportedApiVersion = 3;

        static PrintNodeConfiguration()
        {
            ApiVersion = SupportedApiVersion;
        }

        internal static string GetApiKey()
        {
            if (string.IsNullOrEmpty(_apiKey))
            {
                _apiKey = System.Configuration.ConfigurationManager.AppSettings["PrintNodeApiKey"];
            }

            return _apiKey;
        }

        public static void SetApiKey(string newApiKey)
        {
            _apiKey = newApiKey;
        }

        public static int ApiVersion { get; internal set; }
    }
}
