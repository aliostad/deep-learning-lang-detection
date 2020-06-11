using System;

namespace Freddie
{
    internal class Endpoint
    {
        private const string UriFormat = @"http://{0}.api.mailchimp.com/1.3/";
        private readonly ApiKey _apiKey;

        internal Endpoint(ApiKey apiKey)
        {
            _apiKey = apiKey;
        }

        internal Uri Uri
        {
            get { return new Uri(string.Format(UriFormat, _apiKey.Dc)); }
        }

        internal string ApiKey
        {
            get { return _apiKey.APIKey; }
        }
    }
}
