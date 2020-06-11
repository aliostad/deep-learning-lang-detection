namespace SummonersGift.Data

open FSharp.Data 

//    type Game_1_3 = JsonProvider<"..\ExampleJSON\game-v1.3.JSON">
//    type League_2_5 = JsonProvider<"..\ExampleJSON\league-v2.5.JSON">
//    type MatchHistory_2_2 = JsonProvider<"..\ExampleJSON\matchhistory-v2.2.JSON">
//    type Matc_h2_2 = JsonProvider<"..\ExampleJSON\match-v2.2.JSON">
//    type Stats_1_3_Ranked = JsonProvider<"..\ExampleJSON\stats-v1.3_ranked.JSON">
//    type Stats_1_3_Summary = JsonProvider<"..\ExampleJSON\stats-v1.3_summary.JSON">
//    type Summoner_1_4 = JsonProvider<"..\ExampleJSON\summoner-v1.4.JSON", SampleIsList=true>
//    type League_Entry_2_5 = JsonProvider<"..\ExampleJSON\league-entry-v2.5.json">



module Endpoints =

    let baseUrl = @"https://{region}.api.pvp.net"

    let matchHistoryEndpoint = 
        "/api/lol/{region}/v2.2/matchhistory/{summonerId}?rankedQueues=RANKED_SOLO_5x5&beginIndex={begin}&endIndex={end}"

    let summonerNamesEndpoint =
        @"/api/lol/{region}/v1.4/summoner/by-name/{summonerNames}"

    let summonerLeaguesEndpoint =
        @"/api/lol/{region}/v2.5/league/by-summoner/{summonerIds}/entry"

    let matchEndpoint =
        @"/api/lol/{region}/v2.2/match/{matchId}?includeTimeline={includeTimeline}"

    let addApiKey key (request : string) =
        if request.Contains("?") then
            request + "&api_key=" + key
        else
            request + "?api_key=" + key

    let buildMatchHistoryUrl region (summonerId : int) index key =
        (baseUrl + matchHistoryEndpoint).Replace("{summonerId}",string(summonerId))
            .Replace("{region}", region)
            .Replace("{begin}",string(index)).Replace("{end}",string(index + 15))
        |> addApiKey key

    let buildSummonerNamesUrl region (summonerNames : string seq) key =
        let escapedNames =
            summonerNames
            |> Seq.map System.Web.HttpUtility.HtmlEncode
            |> String.concat ","
        (baseUrl + summonerNamesEndpoint).Replace("{summonerNames}", escapedNames).Replace("{region}", region)
        |> addApiKey key

    let buildSummonerLeagues region (summonerIds : int seq) key =
        (baseUrl + summonerLeaguesEndpoint).Replace("{region}", region)
            .Replace("{summonerIds}", summonerIds |> Seq.map string |> String.concat ",")
        |> addApiKey key

    let buildMatchUrl region (matchId : int) timeline key =
        let timelineTruth = if timeline then "True" else "False"
        (baseUrl + matchEndpoint).Replace("{region}", region)
            .Replace("{matchId}", string(matchId)).Replace("{includeTimeline}", timelineTruth)
        |> addApiKey key