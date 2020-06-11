// Learn more about F# at http://fsharp.net. See the 'F# Tutorial' project
// for more guidance on F# programming.

#load "ApiKeys.fs"


let rate = 500.0 / (60.0 * 10.0)
let waitTime = 1.0 / rate

let startMatch = 1763923202

let wc = new System.Net.WebClient()

let baseUrl = @"https://euw.api.pvp.net/api/lol/euw/v2.2/match/"

let matchesSaveFolder = System.IO.Path.Combine(__SOURCE_DIRECTORY__, """..""", "Data", "Matches")

let getJson saveFolder matchId key =
    let saveFile = System.IO.Path.Combine(saveFolder, string(matchId) + ".json")
    let url = baseUrl + string(matchId) + "?includeTimeline=True&api_key=" + key
    printfn "%s" url
    try 
        let data = wc.DownloadString(url)
        System.IO.File.WriteAllText(saveFile, data)
    with
    | e -> printfn "%A" e

for i in 0..10 do
    getJson matchesSaveFolder (startMatch+i) Keys.lolApiKey
    System.Threading.Thread.Sleep(int(waitTime * 1000.0))
    