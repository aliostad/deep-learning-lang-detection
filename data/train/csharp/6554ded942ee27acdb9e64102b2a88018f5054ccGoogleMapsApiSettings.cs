using System;

namespace NetCore.GoogleMapsApi
{
    public sealed class GoogleMapsApiSettings
    {
        private const string DefaultUrlRootApi = "https://maps.googleapis.com/maps/api";
        public string ApiKey { get; set; }
        public string UrlRootApi { get; set; }
        public GoogleMapsApiSettings(string apiKey)
        {
            if (string.IsNullOrEmpty(apiKey))
                throw new ArgumentNullException("apiKey");
            ApiKey = apiKey;
            UrlRootApi = DefaultUrlRootApi;
        }
    }
}
