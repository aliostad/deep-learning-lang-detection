// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module UserTests

open Helpers
open NUnit.Framework


[<SetUp>]
let setup () =
    Helpers.setup ()
    Helpers.login ()
    
[<Test>]
let ``Fetch User`` () =
    User.fetch "chris"
    |> run
    |> assertApiResult
    |> printfn "%A"

[<Test>]
let ``Fetch Entity by Slug`` () =
    User.entityBySlug "chris"
    |> run
    |> assertApiResult
    |> printfn "%A"

    
[<Test>]
let ``Add Friend`` () =
    User.addFriend "bingo_chief"
    |> run
    |> assertApiResult
    |> printfn "%A"

    
[<Test>]
let ``Remove Friend`` () =
    User.removeFriend "bingo_chief"
    |> run
    |> assertApiResult
    |> printfn "%A"

    
[<Test>]
let ``Block User`` () =
    User.block "bingo_chief"
    |> run
    |> assertApiResult
    |> printfn "%A"

    
[<Test>]
let ``Unblock User`` () =
    User.unblock "bingo_chief"
    |> run
    |> assertApiResult
    |> printfn "%A"

// ## Join errors
