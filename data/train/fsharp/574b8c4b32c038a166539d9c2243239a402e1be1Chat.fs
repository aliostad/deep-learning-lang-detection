// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module ChatTests

open Helpers
open NUnit.Framework


[<SetUp>]
let setup () =
    Helpers.setup ()
    Helpers.login ()

[<Test>]
let Directory () =
    Chat.directory ()
    |> run
    |> assertApiResult
    |> printfn "%A"

[<Test>]
let ``Fetch Entity by Slug`` () =
    Chat.entityBySlug "private_chat_lobby"
    |> run
    |> assertApiResult
    |> printfn "%A"

// ## Join errors

[<Test>]
let Join () =
    Chat.join "private_chat_lobby" true
    |> run
    |> assertApiResult
    |> printfn "%A"

    
[<Test>]
let ``Keep Alive`` () =
    Chat.keepAlive "private_chat_lobby"
    |> run
    |> assertApiResult
    |> printfn "%A"

[<Test>]
let Star () =
    Chat.star "private_chat_lobby"
    |> run
    |> assertApiResult
    |> printfn "%A"

[<Test>]
let Unstar () =
    Chat.unstar "private_chat_lobby"
    |> run
    |> assertApiResult
    |> printfn "%A"