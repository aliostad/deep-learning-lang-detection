namespace FotM.Data

module GlobalSettings =
    let playerLaddersContainer = "snapshots"
    let teamLaddersContainer = "ladders"
    let athenaHistoryContainer = "history"
    let playerUpdatesTopic = "player-updates"
    let teamUpdatesTopic = "team-updates"
    let googleAnalyticsPropertyCode = ""
    let googleAnalyticsPropertyWebSite = ""

type RegionalSettings = {
    code: string;
    blizzardApiRoot: string;
}

module Regions =

    let US = {
        code = "US"
        blizzardApiRoot = "http://us.battle.net/api/wow/leaderboard/"
    }

    let EU = {
        code = "EU"
        blizzardApiRoot = "http://eu.battle.net/api/wow/leaderboard/"
    }

    let KR = {
        code = "KR"
        blizzardApiRoot = "http://kr.battle.net/api/wow/leaderboard/"
    }

    let TW = {
        code = "TW"
        blizzardApiRoot = "http://tw.battle.net/api/wow/leaderboard/"
    }

    let CN = {
        code = "CN"
        blizzardApiRoot = "http://www.battlenet.com.cn/api/wow/leaderboard/"
    }

    let all = [ US; EU; KR; TW; CN ]