using System;
using LolBackdoor.Config;

namespace LolBackdoor.Riot
{
    class RiotException : Exception
    {
        public LolApiConfig ApiConfig { get { return _apiConfig; } }

        private readonly LolApiConfig _apiConfig;

        public RiotException(string message, LolApiConfig apiConfig, Exception webException)
            : base(message, webException)
        {
            _apiConfig = apiConfig;
        }

        public RiotException(string message, LolApiConfig apiConfig) : base (message)
        {
            _apiConfig = apiConfig;
        }
    }
}
