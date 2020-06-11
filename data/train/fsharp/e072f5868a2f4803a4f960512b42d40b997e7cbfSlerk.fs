module Slerk

#if INTERACTIVE
#r @"/Users/gastove/Code/language-tour/fsharp/LanguageTour/bin/Debug/FSharp.Data.dll"
#else
open FSharp.Data
#endif

[<Literal>]
let configJson = "/Users/gastove/Code/language-tour/fsharp/LanguageTour/slack.json"
let apiUrl = "https://slack.com/api/chat.postMessage"

type SlackConfig = JsonProvider<configJson>
let slackConfig = SlackConfig.Load(configJson)

let postMessage msg =
    Http.RequestString(
        apiUrl,
        query=["token", slackConfig.Apikey;
               "channel", "general";
               "text", msg]
        )

[<EntryPoint>]
let main argv =
    let res = postMessage argv.[0]
    printfn "%O" res
    0
