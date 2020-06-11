module Server.WebApiTests

open Suave
open System
open Expecto
open YoLo.Async
open Helpers
open Common

let apiBase : Api.SampleDataApi =  
    { User = 
        { Search = fun _ -> invalidOp "Not Handled" }
      Product = 
        { Search = fun _ -> invalidOp "Not Handled" } }

let fromGet url =
    { HttpContext.empty with
        request = 
            { HttpRequest.empty with 
                url = Uri("http://localhost" + url)
                method = HttpMethod.GET } }

let runWebApiRequest api context =
    async {
        let! (result : HttpContext option) = (App.apiHandler api) context
        return
            match result with
            | Some resultContext ->
                match resultContext.response.content with
                | Bytes b -> 
                    b |> UTF8.toString |> Json.deserialize
                | _ ->
                    invalidOp "Blank"
            | _ -> 
                invalidOp "Not handled"
    } |> Async.RunSynchronously

[<Tests>]
let ``Web Api Tests`` = 
  testList "Web Api Tests" [ 
    testCase "Users.Get" <| fun () -> 
        let items = 
            [({ Id = 1
                EmailAddress = "email"
                Name = "name" } : Models.User)]

        let api = 
            { apiBase with 
                User = 
                    { apiBase.User with
                        Search = fun _ -> items |> Result.Ok |> Async.result }
        }

        let result = runWebApiRequest api (fromGet "/api/user")

        Expect.equal result items "Result isn't correct"
  ]