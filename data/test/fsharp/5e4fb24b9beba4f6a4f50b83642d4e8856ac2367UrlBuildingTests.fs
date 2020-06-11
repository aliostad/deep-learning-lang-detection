namespace SummonersGift.Tests

open System

open NUnit.Framework
open FsUnit

open SummonersGift.Data.Endpoints

[<TestFixture>]
type Urls() =
    let summoner = "proheme"
    let summonerId = 43518871
    let region = "euw"
    let key = "dummy_key"
    let matchId = 2096791975



    let expectedSummoner = "https://euw.api.pvp.net/api/lol/euw/v1.4/summoner/by-name/proheme?api_key=dummy_key"
    let expectedMatchHistory =
        "https://euw.api.pvp.net/api/lol/euw/v2.2/matchhistory/43518871?rankedQueues=RANKED_SOLO_5x5&beginIndex=0&endIndex=15&api_key=dummy_key"
    let expectedLeague =
        "https://euw.api.pvp.net/api/lol/euw/v2.5/league/by-summoner/43518871/entry?api_key=dummy_key"
    let expectedMatch =
        "https://euw.api.pvp.net/api/lol/euw/v2.2/match/2096791975?includeTimeline=True&api_key=dummy_key"

    [<Test>]
    member x.``Correct summoner id req is created`` () =
        let testUrl = buildSummonerNamesUrl region [summoner] key
        testUrl |> should equal expectedSummoner

    [<Test>]
    member x.``Correct match history url is created`` () =
        let testUrl = buildMatchHistoryUrl region summonerId 0 key
        testUrl |> should equal expectedMatchHistory

    [<Test>]
    member x.``Correct summoner league url is created`` () =
        let testUrl = buildSummonerLeagues region [summonerId] key
        testUrl |> should equal expectedLeague

    [<Test>]
    member x.``Correct match url is created`` () =
        let testUrl = buildMatchUrl region matchId true key
        testUrl |> should equal expectedMatch