// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module Helpers

open NUnit.Framework
open System.Net.Security

let run async =
    Async.RunSynchronously async

let assertApiResult result =
    match result with
    | Api.ApiOk result -> result
    | error -> failwithf "ApiError: %A" error

let username = "unitman"
let email = "unitman@test.com"
let password = "testtest"

let printfn (fmt: Format<_,_,_,_>) x = 
    System.Console.WriteLine ((sprintf fmt x).ToString())


let setup () =
    System.Net.ServicePointManager.ServerCertificateValidationCallback <- new RemoteCertificateValidationCallback(fun sender cert chain errors -> true)

    Api.baseUrl <- "https://dev.wireclub.com"
    Api.staticBaseUrl <- "http://dev.wireclub.com"
    Api.channelServer <- "ws://dev.wireclub.com:8888/events"
    
let login () =
    run (Account.login username password) |> assertApiResult |> ignore

let teardown () =
    Account.logout ()
