using BattleNetApi.Api.ApiInterfaces;
using BattleNetApi.Api.Enums;

namespace BattleNetApi.Api
{
    public class BattleNetApiClient
    {
        private string _apiClientKey { get; set; }
        private Region _region { get; set; }
        private Locale _locale { get; set; }

        protected string RegionString
        {
            get
            {
                return _region.ToString().ToLower();
            }
        }
        protected string LocaleString
        {
            get
            {
                return _locale.ToString();
            }
        }

        public OAuthApi OAuthApi { get; private set; }

        public WoWCommunityApi WowCommunityApi { get; private set; }

        public BattleNetApiClient(string apiClientKey, Region region = Region.US, Locale locale = Locale.en_US)
        {
            _apiClientKey = apiClientKey;
            _region = region;
            _locale = locale;

            InitializeApiInterfaces();
        }

        private void InitializeApiInterfaces()
        {
            OAuthApi = new OAuthApi(_region, _locale);
            WowCommunityApi = new WoWCommunityApi(_apiClientKey, _region, _locale);
        }
    }
}
