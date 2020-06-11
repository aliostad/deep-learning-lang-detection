using LolBackdoor.APIs.ChampionApis;
using LolBackdoor.APIs.GameApis;
using System.Collections.Generic;
using System.Linq;
using LolBackdoor.APIs;
using LolBackdoor.APIs.LeagueApis;
using LolBackdoor.APIs.StatusApis;
using LolBackdoor.APIs.MatchApis;
using LolBackdoor.APIs.MatchHistoryApis;
using LolBackdoor.APIs.StaticDataApis;
using LolBackdoor.APIs.StatsApis;
using LolBackdoor.APIs.SummonerApis;
using LolBackdoor.APIs.TeamApis;
using LolBackdoor.Config;

namespace LolBackdoor
{
    public class LolServer
    {

        /// <summary>
        ///     Yolo
        /// </summary>

        public LolRegion Region
        {
            get { return _region; }
        }

        public ILolChampionApi ChampionApi
        {
            get { return (ILolChampionApi) _apis[LolApi.Champion]; }
        }

        public ILolGameApi GameApi
        {
            get { return (ILolGameApi) _apis[LolApi.Game]; }
        }

        public ILolLeagueApi LeagueApi
        {
            get { return (ILolLeagueApi)_apis[LolApi.League]; }
        }

        public ILolMatchApi MatchApi
        {
            get { return (ILolMatchApi)_apis[LolApi.Match]; }
        }

        public ILolMatchHistoryApi MatchHistoryApi
        {
            get { return (ILolMatchHistoryApi)_apis[LolApi.MatchHistory]; }
        }

        public ILolStaticDataApi StaticDataApi
        {
            get { return (ILolStaticDataApi)_apis[LolApi.StaticData]; }
        }

        public ILolStatsApi StatsApi
        {
            get { return (ILolStatsApi)_apis[LolApi.Stats]; }
        }

        public ILolStatusApi StatusApi
        {
            get { return (ILolStatusApi)_apis[LolApi.Status]; }
        }

        public ILolSummonerApi SummonerApi
        {
            get { return (ILolSummonerApi)_apis[LolApi.Summoner]; }
        }

        public ILolTeamApi TeamApi
        {
            get { return (ILolTeamApi)_apis[LolApi.Team]; }
        }

        private readonly Dictionary<LolApi, ILolApi> _apis;
        private readonly LolRegion _region;
        private readonly string _serverEndpoint;

        internal LolServer(LolServerConfig config)
        {
            _region = config.Region;
            _serverEndpoint = config.Endpoint;
            _apis = config.ApiConfigs.Values.ToDictionary(apiConfig => apiConfig.Api,
                LolApiReflectionHelper.GetLolApi);
        }


    }
}
