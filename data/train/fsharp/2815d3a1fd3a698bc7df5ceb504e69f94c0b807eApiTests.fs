module Server.ApiTests

open Expecto
open Common
open System

let baseRepository : Repository.SampleDataRepository =
    { User = 
        { Search = fun _ -> invalidOp "Not handled" }
      Product = 
        { Search = fun _ -> invalidOp "Not handled"} }

let runApiRequest request =
    request
    |> Async.RunSynchronously
    |> function
        | Result.Ok r -> r
        | _ -> invalidOp "Error"

[<Tests>]
let ``Api Tests`` = 
  testList "Api Tests" [
    testCase "Users.get" <| fun _ ->
        let items = 
            [({ Id = 1
                EmailAddress = "email"
                Name = "name" } : Models.User)]

        let repository = 
            { baseRepository with
                User =
                    { baseRepository.User with
                        Search = fun _ -> items |> Seq.ofList }}

        let result =
            Server.Api.User.search repository
            |> runApiRequest

        Expect.equal result items "Result isn't correct"
  ]