using System;
using System.Collections.Generic;
using System.Text;

namespace RiotGamesApi.Interfaces
{
    public interface IApiBuilder
    {
        IApiOption RiotGamesApiOptions { get; }

        IApiOption Build();

        IApiBuilder UseApiUrl(string _url);

        IApiBuilder UseRiotApiKey(string riotApiKey);

        IApiBuilder UseTournamentApi(Func<Models.RiotGamesApi, Models.RiotGamesApi> action);

        IApiBuilder UseNonStaticApi(Func<Models.RiotGamesApi, Models.RiotGamesApi> action);

        IApiBuilder UseStaticApi(Func<Models.RiotGamesApi, Models.RiotGamesApi> action);

        IApiBuilder UseStatusApi(Func<Models.RiotGamesApi, Models.RiotGamesApi> action);
    }
}