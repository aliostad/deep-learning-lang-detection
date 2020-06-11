module FSharpNews.Tests.DataPull.Service.RepositoriesTests

open System
open NUnit.Framework
open Suave.Types
open Suave.Http
open FSharpNews.Data
open FSharpNews.Utils
open FSharpNews.Tests.Core

[<SetUp>]
let Setup() = do Storage.deleteAll()

[<Test>]
let ``One repo returned by search api => one activity in storage``() =
    use gh = GitHubApi.runServer (GET >>= url GitHubApi.repoPath
                                      >>= (set_mime_type "application/json"
                                      >> OK TestData.Repositories.json))
    do ServiceApplication.startAndSleep Repos

    Storage.getAllActivities()
    |> List.map fst
    |> List.exactlyOne
    |> assertEqual TestData.Repositories.activity
