module ClientApi

open Fable.Core
open Fable.PowerPack

let clientApi : Common.Api.SampleDataApi =
    let run fetchRequest =
        async {
            let! result =
                fetchRequest
                |> Async.AwaitPromise
                |> Async.Catch

            return 
                match result with
                | Choice1Of2 r -> Result.Ok r
                | Choice2Of2 ex -> 
                    printfn "Error %A" ex
                    Result.Error "Error" }

    { User = 
        { Search = fun _ -> Fetch.fetchAs<_> "/api/user" [] |> run }
      Product =
        { Search = fun _ -> Fetch.fetchAs<_> "/api/product" [] |> run } }