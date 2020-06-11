#I "../packages/Octokit/lib/net45"
#I "../packages/Wox.Plugin/lib/net452"

#r "Octokit.dll"
#r "Wox.Plugin.dll"

#load "GithubPlugin.fs"
open Wox.Plugin
open Wox.Plugin.Github

let printResult (r:Result) =
    printfn "Title: \t\t %s \nSubTitle: \t %s " r.Title r.SubTitle

let plugin = GithubPlugin()

// should return a list of repositories
Seq.iter printResult <| plugin.ProcessQuery [ "repos"; "wox" ]

// should return a list of users
Seq.iter printResult <| plugin.ProcessQuery [ "users"; "john" ]

// should return a list of issues
Seq.iter printResult <| plugin.ProcessQuery [ "issues"; "wox-launcher/wox" ]

// should return a list of PRs
Seq.iter printResult <| plugin.ProcessQuery [ "pr"; "wox-launcher/wox" ]

// should return stats/issues/PRs
Seq.iter printResult <| plugin.ProcessQuery [ "repo"; "wox-launcher/wox" ]

// should return search suggestions
Seq.iter printResult <| plugin.ProcessQuery [ "search term" ]

// should return usage help
Seq.iter printResult <| plugin.ProcessQuery [ ]

// should return that repo doesn't exist
Seq.iter printResult <| plugin.ProcessQuery [ "repo"; "repothat/doesntexist" ]
Seq.iter printResult <| plugin.ProcessQuery [ "issues"; "repothat/doesntexist" ]
Seq.iter printResult <| plugin.ProcessQuery [ "pr"; "repothat/doesntexist" ]

// should return no results
Seq.iter printResult <| plugin.ProcessQuery [ "repos"; "repothatdoesntexist" ]
Seq.iter printResult <| plugin.ProcessQuery [ "users"; "userthatdoesntexist" ]